{ lib, stdenv, fetchFromGitHub, fetchpatch, inkscape, xcursorgen }:

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

  patches = [
    # Remove when https://github.com/numixproject/numix-cursor-theme/pull/7 is merged
    (fetchpatch {
      url = "https://github.com/stephaneyfx/numix-cursor-theme/commit/3b647bf768cebb8f127b88e3786f6a9640460197.patch";
      sha256 = "174kmhlvv76wwvndkys78aqc32051sqg3wzc0xg6b7by4agrbg76";
      name = "support-inkscape-1-in-numix-cursor-theme.patch";
    })
  ];

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
