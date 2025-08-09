{
  buildPecl,
  lib,
  pkg-config,
  rrdtool,
}:

buildPecl {
  pname = "rrd";

  version = "2.0.3";
  hash = "sha256-pCFh5YzcioU7cs/ymJidy96CsPdkVt1ZzgKFTJK3MPc=";

  buildInputs = [
    rrdtool
  ];

  nativeBuildInputs = [
    pkg-config
  ];

  # Fix GCC 14 build.
  # from incompatible pointer type [-Wincompatible-pointer-types
  env.NIX_CFLAGS_COMPILE = "-Wno-error=incompatible-pointer-types";

  meta = {
    description = "PHP bindings to RRD tool system";
    license = lib.licenses.bsd0;
    homepage = "https://github.com/php/pecl-processing-rrd";
    teams = [ lib.teams.wdz ];
  };
}
