{
  lib,
  stdenv,
  fetchFromGitHub,
  gitUpdater,
  libtool,
  autoreconfHook,
  pkg-config,
  autoconf-archive,
  libxml2,
  icu,
  zlib,
  bzip2,
  libtar,
  frog,
  timblserver,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "ticcutils";
<<<<<<< HEAD
  version = "0.37";
=======
  version = "0.36";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)

  src = fetchFromGitHub {
    owner = "LanguageMachines";
    repo = "ticcutils";
    tag = "v${finalAttrs.version}";
<<<<<<< HEAD
    hash = "sha256-jpwiRVpzALBUf4DxpRblEPLgXXOh2luHnTQg8nuQAwo=";
=======
    hash = "sha256-iehbLpVdcJ9PPI4iwUweZjsD+r1dNFoOr38W53JpGdU=";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  };

  nativeBuildInputs = [
    pkg-config
    autoreconfHook
  ];

  buildInputs = [
    libtool
    autoconf-archive
    libxml2
    icu
    # optional:
    zlib
    bzip2
    libtar
    # broken but optional: boost
  ];

  passthru = {
    updateScript = gitUpdater { rev-prefix = "v"; };
    tests = {
      /**
        Reverse dependencies. Does not respect overrides.
      */
      reverseDependencies = lib.recurseIntoAttrs {
        inherit frog timblserver;
      };
    };
  };

<<<<<<< HEAD
  meta = {
    description = "This module contains useful functions for general use in the TiCC software stack and beyond";
    homepage = "https://github.com/LanguageMachines/ticcutils";
    license = lib.licenses.gpl3;
    platforms = lib.platforms.all;
    maintainers = with lib.maintainers; [ roberth ];
=======
  meta = with lib; {
    description = "This module contains useful functions for general use in the TiCC software stack and beyond";
    homepage = "https://github.com/LanguageMachines/ticcutils";
    license = licenses.gpl3;
    platforms = platforms.all;
    maintainers = with maintainers; [ roberth ];
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  };

})
