{
  stdenv,
  texinfo,
  flex,
  bison,
  fetchFromGitHub,
  stdenvNoLibc,
  buildPackages,
}:

stdenvNoLibc.mkDerivation {
  pname = "vc4-newlib";
  version = "0-unstable-2017-01-08";

  src = fetchFromGitHub {
    owner = "itszor";
    repo = "newlib-vc4";
    rev = "89abe4a5263d216e923fbbc80495743ff269a510";
    hash = "sha256-W+G3ctinyfdz5ZtEYFdCGg7ts4abyRWxpQ4Za8EmOYw=";
  };
  dontUpdateAutotoolsGnuConfigScripts = true;
  configurePlatforms = [ "target" ];
  enableParallelBuilding = true;

  nativeBuildInputs = [
    texinfo
    flex
    bison
  ];
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

  meta = {
    homepage = "https://github.com/itszor/newlib-vc4";
  };
}
