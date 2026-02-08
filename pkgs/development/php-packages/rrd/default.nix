{
  buildPecl,
  lib,
  pkg-config,
  rrdtool,
  fetchpatch,
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

  patches = [
    # PHP 8.5 compatibility patch
    (fetchpatch {
      url = "https://github.com/php/pecl-processing-rrd/pull/4/commits/dd4856dc89499a0141b1710e791f0e1096c7b244.patch";
      hash = "sha256-ES+cMhMBUubFB5TpTZzzKKfEK2cY737z7zCuNy4XF8Y=";
    })
  ];

  # Fix GCC 14 build.
  # from incompatible pointer type [-Wincompatible-pointer-types
  env.NIX_CFLAGS_COMPILE = "-Wno-error=incompatible-pointer-types";

  meta = {
    description = "PHP bindings to RRD tool system";
    license = lib.licenses.bsd0;
    homepage = "https://github.com/php/pecl-processing-rrd";
  };
}
