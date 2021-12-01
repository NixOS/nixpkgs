{ lib, stdenv, fetchurl }:

stdenv.mkDerivation rec {
  pname = "dev86";
  version = "0.16.21";

  src = fetchurl {
    url = "http://v3.sk/~lkundrak/dev86/Dev86src-${version}.tar.gz";
    sha256 = "154dyr2ph4n0kwi8yx0n78j128kw29rk9r9f7s2gddzrdl712jr3";
  };

  hardeningDisable = [ "format" ];

  makeFlags = [ "PREFIX=$(out)" ];

  # Parallel builds are not supported due to build process structure:
  # tools are built sequentially in submakefiles and are reusing the
  # same targets as dependencies. Building dependencies in parallel
  # from different submakes is not synchronized and fails:
  #     make[3]: Entering directory '/build/dev86-0.16.21/libc'
  #     Unable to execute as86.
  enableParallelBuilding = false;

  meta = {
    description = "Linux 8086 development environment";
    homepage = "https://github.com/lkundrak/dev86";
    platforms = lib.platforms.linux;
  };
}
