{
  buildPecl,
  lib,
  php,
  pkg-config,
  rrdtool,
}:

buildPecl {
  pname = "rrd";

  version = "2.0.4";
  hash = "sha256-/qEDdFHHI2cKSPHb2vmov1GnbKo9Nhy1ujsDZ70fLPs=";

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
    broken = lib.versionAtLeast php.version "8.6";
    description = "PHP bindings to RRD tool system";
    license = lib.licenses.bsd0;
    homepage = "https://github.com/php/pecl-processing-rrd";
  };
}
