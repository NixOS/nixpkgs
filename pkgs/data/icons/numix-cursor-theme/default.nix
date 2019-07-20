{ stdenv, fetchFromGitHub, inkscape, xcursorgen }:

stdenv.mkDerivation rec {
  version = "1.1";
  package-name = "numix-cursor-theme";
  name = "${package-name}-${version}";

  src = fetchFromGitHub {
    owner = "numixproject";
    repo = package-name;
    rev = "v${version}";
    sha256 = "0p8h48wsy3z5dz9vdnp01fpn6q8ky0h74l5qgixlip557bsa1spi";
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

  meta = with stdenv.lib; {
    description = "Numix cursor theme";
    homepage = https://numixproject.github.io;
    license = licenses.gpl3;
    platforms = platforms.all;
    maintainers = with maintainers; [ offline ];
  };
}
