{
  version,
  urls,
  sha256,
  patches ? [ ],
}:

{
  lib,
  stdenv,
  fetchurl,
  gmp,
  autoreconfHook,
  buildPackages,
  updateAutotoolsGnuConfigScriptsHook,
}:

stdenv.mkDerivation {
  pname = "isl";
  inherit version;

  src = fetchurl {
    inherit urls sha256;
  };

  inherit patches;

  strictDeps = true;
  depsBuildBuild = lib.optionals (lib.versionAtLeast version "0.23") [ buildPackages.stdenv.cc ];
  nativeBuildInputs =
    lib.optionals (stdenv.hostPlatform.isRiscV && lib.versionOlder version "0.23") [
      autoreconfHook
    ]
    ++ [
      # needed until config scripts are updated to not use /usr/bin/uname on FreeBSD native
      updateAutotoolsGnuConfigScriptsHook
    ];
  buildInputs = [ gmp ];

  configureFlags = [
    "--with-gcc-arch=${stdenv.hostPlatform.gcc.arch or "unknown"}" # https://repo.or.cz/isl.git/blob/24244001b17ffaebf3df5a668e8f6ca8697e99da:/m4/ax_gcc_archflag.m4
  ];

  enableParallelBuilding = true;

  makeFlags = lib.optional stdenv.hostPlatform.isPE "LDFLAGS=-no-undefined";

  meta = {
    homepage = "https://libisl.sourceforge.io/";
    license = lib.licenses.lgpl21;
    description = "Library for manipulating sets and relations of integer points bounded by linear constraints";
    platforms = lib.platforms.all;
  };
}
