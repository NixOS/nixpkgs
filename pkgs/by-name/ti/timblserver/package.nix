{
  lib,
  stdenv,
  fetchFromGitHub,
  gitUpdater,
  autoreconfHook,
  bzip2,
  icu,
  libtar,
  libtool,
  pkg-config,
  autoconf-archive,
  libxml2,
  ticcutils,
  timbl,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "timblserver";
  version = "1.19";

  src = fetchFromGitHub {
    owner = "LanguageMachines";
    repo = "timblserver";
    tag = "v${finalAttrs.version}";
    hash = "sha256-GNHPr8l+j1HNDyb6ZrfeBgd2kN5oUN6M9a8Gs+7v79w=";
  };

  nativeBuildInputs = [
    pkg-config
    autoreconfHook
  ];
  buildInputs = [
    bzip2
    icu
    libtar
    libtool
    autoconf-archive
    libxml2
    ticcutils
    timbl
  ];

  passthru = {
    updateScript = gitUpdater { rev-prefix = "v"; };
  };

  meta = with lib; {
    description = "This server for TiMBL implements several memory-based learning algorithms";
    homepage = "https://github.com/LanguageMachines/timblserver/";
    license = licenses.gpl3;
    platforms = platforms.all;
    maintainers = with maintainers; [ roberth ];

    longDescription = ''
      This implements a server for TiMBL. TiMBL is an open source software package implementing several memory-based learning algorithms, among which IB1-IG, an implementation of k-nearest neighbor classification with feature weighting suitable for symbolic feature spaces, and IGTree, a decision-tree approximation of IB1-IG. All implemented algorithms have in common that they store some representation of the training set explicitly in memory. During testing, new cases are classified by extrapolation from the most similar stored cases.

      For over fifteen years TiMBL has been mostly used in natural language processing as a machine learning classifier component, but its use extends to virtually any supervised machine learning domain. Due to its particular decision-tree-based implementation, TiMBL is in many cases far more efficient in classification than a standard k-nearest neighbor algorithm would be.
    '';
  };

})
