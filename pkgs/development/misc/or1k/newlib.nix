{
  stdenv,
  fetchFromGitHub,
  stdenvNoLibc,
  buildPackages,
}:

stdenvNoLibc.mkDerivation {
  pname = "or1k-newlib";
  version = "0-unstable-2018-11-05";

  src = fetchFromGitHub {
    owner = "openrisc";
    repo = "newlib";
    rev = "8ac94ca7bbe4ceddafe6583ee4766d3c15b18ac8";
    sha256 = "0hzhijmry5slpp6x12pgng8v7jil3mn18ahrhnw431lqrs1cma0s";
  };

  depsBuildBuild = [ buildPackages.stdenv.cc ];

  # newlib expects CC to build for build platform, not host platform
  preConfigure = ''
    export CC=cc
  '';

  configurePlatforms = [
    "build"
    "target"
  ];
  configureFlags = [
    "--host=${stdenv.buildPlatform.config}"

    "--disable-newlib-supplied-syscalls"
    "--disable-nls"
    "--enable-newlib-io-long-long"
    "--enable-newlib-register-fini"
    "--enable-newlib-retargetable-locking"
  ];

  dontDisableStatic = true;

  passthru = {
    incdir = "/${stdenv.targetPlatform.config}/include";
    libdir = "/${stdenv.targetPlatform.config}/lib";
  };
}
