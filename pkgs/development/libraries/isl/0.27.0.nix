{
  lib,
  stdenv,
  fetchurl,
  gmp,
  buildPackages,
  updateAutotoolsGnuConfigScriptsHook,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "isl";
  version = "0.27";

  src = fetchurl {
    urls = [
      "mirror://sourceforge/libisl/isl-${finalAttrs.version}.tar.xz"
      "https://libisl.sourceforge.io/isl-${finalAttrs.version}.tar.xz"
    ];
    hash = "sha256-bYurtZ57Zy6Mt4cOh08/e4E7bgDmrz+LBPdXmWVkPVw=";
  };

  strictDeps = true;
  depsBuildBuild = [ buildPackages.stdenv.cc ];
  nativeBuildInputs = [
    # needed until config scripts are updated to not use /usr/bin/uname on FreeBSD native
    updateAutotoolsGnuConfigScriptsHook
  ];
  buildInputs = [ gmp ];

  configureFlags = [
    "--with-gcc-arch=generic" # don't guess -march=/mtune=
  ];

  enableParallelBuilding = true;

  meta = {
    homepage = "https://libisl.sourceforge.io/";
    license = lib.licenses.lgpl21;
    description = "Library for manipulating sets and relations of integer points bounded by linear constraints";
    platforms = lib.platforms.all;
  };
})
