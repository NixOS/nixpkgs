{ stdenv, lib, fetchFromGitHub, glib, gjs, typescript, unstableGitUpdater }:

stdenv.mkDerivation rec {
  pname = "gnome-shell-extension-pop-shell";
  version = "1.2.0-unstable-2024-09-18";

  src = fetchFromGitHub {
    owner = "pop-os";
    repo = "shell";
    rev = "ced54427487905f42447a07dabff7101b700b5c9";
    hash = "sha256-V415QjQYTZezNOpTRPMPRidSGWaYoBkbSVXSaBIE7zQ=";
  };

  nativeBuildInputs = [ glib gjs typescript ];

  buildInputs = [ gjs ];

  patches = [
    ./fix-gjs.patch
  ];

  makeFlags = [ "XDG_DATA_HOME=$(out)/share" ];

  passthru = {
    extensionUuid = "pop-shell@system76.com";
    extensionPortalSlug = "pop-shell";
    updateScript = unstableGitUpdater { };
  };

  postPatch = ''
    for file in */main.js; do
      substituteInPlace $file --replace "gjs" "${gjs}/bin/gjs"
    done
  '';

  preFixup = ''
    chmod +x $out/share/gnome-shell/extensions/pop-shell@system76.com/*/main.js
  '';

  meta = with lib; {
    description = "Keyboard-driven layer for GNOME Shell";
    license = licenses.gpl3Only;
    platforms = platforms.linux;
    maintainers = [ maintainers.genofire ];
    homepage = "https://github.com/pop-os/shell";
  };
}
