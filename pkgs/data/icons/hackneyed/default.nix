{ lib, fetchzip, stdenvNoCC, fetchFromGitLab, xcursorgen, imagemagick6, inkscape }:

stdenvNoCC.mkDerivation rec {
  pname = "hackneyed";
  version = "0.8.2";

  src = fetchFromGitLab {
    owner = "Enthymeme";
    repo = "hackneyed-x11-cursors";
    rev = version;
    sha256 = "sha256-Wtrw/EzxCj4cAyfdBp0OJE4+c6FouW7+b6nFTLxdXNY=";
  };

  buildInputs = [ imagemagick6 inkscape xcursorgen ];

  postPatch = ''
    patchShebangs *.sh
    substituteInPlace make-png.sh \
      --replace /usr/bin/inkscape ${inkscape}/bin/inkscape
  '';

  enableParallelBuilding = true;

  makeFlags = [ "PREFIX=$(out)" ];
  buildFlags = [ "theme" "theme.left" ];

  meta = with lib; {
    homepage = "https://gitlab.com/Enthymeme/hackneyed-x11-cursors";
    description = "A scalable cursor theme that resembles Windows 3.x/NT 3.x cursors";
    platforms = platforms.all;
    license = licenses.mit;
    maintainers = with maintainers; [ somasis ];
  };
}
