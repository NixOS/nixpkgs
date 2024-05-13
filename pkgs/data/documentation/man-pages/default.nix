{ lib, stdenv, fetchurl, locale }:

stdenv.mkDerivation (finalAttrs: {
  pname = "man-pages";
  version = "6.7";

  src = fetchurl {
    url = "mirror://kernel/linux/docs/man-pages/man-pages-${finalAttrs.version}.tar.xz";
    hash = "sha256-gkA61LwXqtuST2hji3nWkwssvVUVMSSKepaId52077I=";
  };

  nativeBuildInputs = lib.optionals stdenv.isDarwin [ locale ];

  makeFlags = [
    # Clobber /usr/bin/env with the one in PATH.
    "SHELL=env"
    "prefix=${placeholder "out"}"
  ];

  dontBuild = true;

  outputDocdev = "out";

  enableParallelInstalling = true;

  meta = with lib; {
    description = "Linux development manual pages";
    homepage = "https://www.kernel.org/doc/man-pages/";
    license = licenses.gpl2Plus;
    platforms = with platforms; unix;
    priority = 30; # if a package comes with its own man page, prefer it
  };
})
