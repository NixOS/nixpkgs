{
  version,
  urls,
  sha256,
  configureFlags ? [ ],
  patches ? [ ],
}:

{
  lib,
  stdenv,
  fetchurl,
  gmp,
  autoreconfHook,
  buildPackages,
}:

stdenv.mkDerivation {
  pname = "isl";
  inherit version;

  src = fetchurl {
    inherit urls sha256;
  };

  inherit patches;

  strictDeps = true;
  depsBuildBuild = lib.optionals (lib.versionAtLeast version "0.24") [ buildPackages.stdenv.cc ];
  nativeBuildInputs = lib.optionals (stdenv.hostPlatform.isRiscV && lib.versionOlder version "0.24") [
    autoreconfHook
  ];
  buildInputs = [ gmp ];

  inherit configureFlags;

  enableParallelBuilding = true;

  meta = {
    homepage = "https://libisl.sourceforge.io/";
    license = lib.licenses.lgpl21;
    description = "Library for manipulating sets and relations of integer points bounded by linear constraints";
    platforms = lib.platforms.all;
  };
}
