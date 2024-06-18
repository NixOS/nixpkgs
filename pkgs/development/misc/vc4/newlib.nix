{ stdenv, texinfo, flex, bison, fetchFromGitHub, stdenvNoLibc, buildPackages }:

stdenvNoLibc.mkDerivation {
  name = "newlib";
  src = fetchFromGitHub {
    owner = "itszor";
    repo = "newlib-vc4";
    rev = "89abe4a5263d216e923fbbc80495743ff269a510";
    sha256 = "131r4v0nn68flnqibjcvhsrys3hs89bn0i4vwmrzgjd7v1rbgqav";
  };
  dontUpdateAutotoolsGnuConfigScripts = true;
  configurePlatforms = [ "target" ];
  enableParallelBuilding = true;

  nativeBuildInputs = [ texinfo flex bison ];
  depsBuildBuild = [ buildPackages.stdenv.cc ];
  # newlib expects CC to build for build platform, not host platform
  preConfigure = ''
    export CC=cc
  '';

  dontStrip = true;

  passthru = {
    incdir = "/${stdenv.targetPlatform.config}/include";
    libdir = "/${stdenv.targetPlatform.config}/lib";
  };
}
