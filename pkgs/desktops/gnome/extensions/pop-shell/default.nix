{ stdenv, lib, fetchFromGitHub, glib, nodePackages, gjs }:

stdenv.mkDerivation rec {
  pname = "gnome-shell-extension-pop-shell";
  version = "unstable-2023-04-05";

  src = fetchFromGitHub {
    owner = "pop-os";
    repo = "shell";
    rev = "a3a1b7bb832838fec2ea875954d33443fc680912";
    hash = "sha256-B82UKtJRDDejBX1UBBIjPRO8rzHNapJRi8wv6dT7oJ8=";
  };

  nativeBuildInputs = [ glib nodePackages.typescript gjs ];

  buildInputs = [ gjs ];

  patches = [
    ./fix-gjs.patch
  ];

  makeFlags = [ "XDG_DATA_HOME=$(out)/share" ];

  passthru = {
    extensionUuid = "pop-shell@system76.com";
    extensionPortalSlug = "pop-shell";
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
