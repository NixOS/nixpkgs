{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
  zlib,
  libpng,
  bzip2,
  libusb-compat-0_1,
  openssl,
}:

stdenv.mkDerivation {
  pname = "xpwn";
  version = "0.5.8-unstable-2024-04-01";

  src = fetchFromGitHub {
    owner = "planetbeing";
    repo = "xpwn";
    rev = "20c32e5c12d1b22a9d55a59a0ff6267f539b77f4";
    hash = "sha256-wOSIaeNjZOKoeL4padP6UWY1O75qqHuFuSMrdCOLI2s=";
  };

  env.NIX_CFLAGS_COMPILE = toString [
    # Workaround build failure on -fno-common toolchains:
    #   ld: ../ipsw-patch/libxpwn.a(libxpwn.c.o):(.bss+0x4): multiple definition of
    #     `endianness'; CMakeFiles/xpwn-bin.dir/src/xpwn.cpp.o:(.bss+0x0): first defined here
    "-fcommon"

    # Fix build on GCC 14
    "-Wno-implicit-int"
    "-Wno-incompatible-pointer-types"
  ];

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
  buildInputs = [
    zlib
    libpng
    bzip2
    libusb-compat-0_1
    openssl
  ];

  meta = with lib; {
    broken = stdenv.hostPlatform.isDarwin;
    homepage = "http://planetbeing.lighthouseapp.com/projects/15246-xpwn";
    description = "Custom NOR firmware loader/IPSW generator for the iPhone";
    license = licenses.gpl3Plus;
    platforms = with platforms; linux ++ darwin;
  };
}
