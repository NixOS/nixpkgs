{ stdenv, fetchurl, texinfo, flex, bison, crossLibcStdenv, buildPackages }:

let version = "2.0.0";
in

crossLibcStdenv.mkDerivation {
  pname = "newlib";
  inherit version;
  src = fetchurl {
    url = "ftp://sourceware.org/pub/newlib/newlib-${version}.tar.gz";
    sha256 = "12idyyd7dmn01z44f3j44k89dmyw7ms2ka0s48xpqpij568rxhj9";
  };

  nativeBuildInputs = [ texinfo flex bison ];
  depsBuildBuild = [ buildPackages.stdenv.cc ];

  # newlib expects CC to build for build platform, not host platform
  preConfigure = ''
    export CC=cc
  '';

  configurePlatforms = [ "target" ];
  configureFlags = [
    "--host=${stdenv.buildPlatform.config}"
    "--disable-multilib"
    "--disable-shared"
  ];

  enableParallelBuilding = true;
  dontStrip = true;

  passthru = {
    incdir = "/${stdenv.targetPlatform.config}/include";
    libdir = "/${stdenv.targetPlatform.config}/lib";
  };
}
