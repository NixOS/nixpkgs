{ lib, stdenvNoCC, fetchFromGitLab, imagemagick, inkscape, xcursorgen }:

stdenvNoCC.mkDerivation rec {
  pname = "hackneyed";
  version = "0.9.1";

  src = fetchFromGitLab {
    owner = "Enthymeme";
    repo = "hackneyed-x11-cursors";
    rev = version;
    hash = "sha256-+7QtHgBuhJtQejiHeZ+QoedJo24LqSY51XRVLv9Ho2g=";
  };

  nativeBuildInputs = [ imagemagick inkscape xcursorgen ];

  postPatch = ''
    patchShebangs *.sh
  '';

  enableParallelBuilding = true;

  makeFlags = [
    "INKSCAPE=inkscape"
    "INSTALL=install"
    "PREFIX=$(out)"
    "VERBOSE=1"
    "XCURSORGEN=xcursorgen"
  ];

  buildFlags = [ "theme" "theme.left" ];

  # The Makefile declares a dependency on the value of $(INKSCAPE) for some reason;
  # it's unnecessary for building though.
  prePatch = ''
    substituteInPlace GNUmakefile \
        --replace 'inkscape-version: $(INKSCAPE)' 'inkscape-version:'
  '';

  meta = with lib; {
    homepage = "https://gitlab.com/Enthymeme/hackneyed-x11-cursors";
    description = "Scalable cursor theme that resembles Windows 3.x/NT 3.x cursors";
    platforms = platforms.all;
    license = licenses.mit;
    maintainers = with maintainers; [ somasis ];
  };
}
