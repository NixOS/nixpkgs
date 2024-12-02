{ lib, stdenv, fetchFromGitHub, cmake, zlib, libpng, bzip2, libusb-compat-0_1, openssl }:

stdenv.mkDerivation rec {
  pname = "xpwn";
  version = "0.5.8git";

  src = fetchFromGitHub {
    owner = "planetbeing";
    repo = pname;
    rev = "ac362d4ffe4d0489a26144a1483ebf3b431da899";
    sha256 = "1qw9vbk463fpnvvvfgzxmn9add2p30k832s09mlycr7z1hrh3wyf";
  };

  # Workaround build failure on -fno-common toolchains:
  #   ld: ../ipsw-patch/libxpwn.a(libxpwn.c.o):(.bss+0x4): multiple definition of
  #     `endianness'; CMakeFiles/xpwn-bin.dir/src/xpwn.cpp.o:(.bss+0x0): first defined here
  env.NIX_CFLAGS_COMPILE = "-fcommon";

  preConfigure = ''
    rm BUILD # otherwise `mkdir build` fails on case insensitive file systems
    sed -r -i \
      -e 's/(install.*TARGET.*DESTINATION )\.\)/\1bin)/' \
      -e 's!(install.*(FILE|DIR).*DESTINATION )([^)]*)!\1share/xpwn/\3!' \
      */CMakeLists.txt
    sed -i -e '/install/d' CMakeLists.txt
  '';

  strictDeps = true;
  nativeBuildInputs = [ cmake ];
  buildInputs = [ zlib libpng bzip2 libusb-compat-0_1 openssl ];

  meta = with lib; {
    broken = stdenv.hostPlatform.isDarwin;
    homepage    = "http://planetbeing.lighthouseapp.com/projects/15246-xpwn";
    description = "Custom NOR firmware loader/IPSW generator for the iPhone";
    license     = licenses.gpl3Plus;
    platforms   = with platforms; linux ++ darwin;
  };
}
