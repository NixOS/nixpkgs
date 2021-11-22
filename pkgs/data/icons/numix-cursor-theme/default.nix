{ lib, stdenv, fetchFromGitHub, inkscape, xcursorgen }:

stdenv.mkDerivation rec {
  version = "1.2";
  package-name = "numix-cursor-theme";
  name = "${package-name}-${version}";

  src = fetchFromGitHub {
    owner = "numixproject";
    repo = package-name;
    rev = "v${version}";
    sha256 = "1q3w5i0h3ly6i7s9pqjdrb14kp89i78s0havri7lhiqyxizjvcvh";
  };

  nativeBuildInputs = [ inkscape xcursorgen ];

  buildPhase = ''
    patchShebangs .
    HOME=$TMP ./build.sh
  '';

  installPhase = ''
    install -dm 755 $out/share/icons
    cp -dr --no-preserve='ownership' Numix-Cursor{,-Light} $out/share/icons/
  '';

  meta = with lib; {
    description = "Numix cursor theme";
    homepage = "https://numixproject.github.io";
    license = licenses.gpl3;
    platforms = platforms.all;
    maintainers = with maintainers; [ offline ];
  };
}
