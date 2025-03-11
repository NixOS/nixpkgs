{
  lib,
  stdenv,
  fetchurl,
  automake,
  autoconf,
  libtool,
  pkg-config,
  autoconf-archive,
  libxml2,
  bzip2,
  libtar,
  languageMachines,
}:

let
  release = lib.importJSON ./release-info/LanguageMachines-timbl.json;
in

stdenv.mkDerivation {
  pname = "timbl";
  version = release.version;
  src = fetchurl {
    inherit (release) url sha256;
    name = "timbl-${release.version}.tar.gz";
  };
  nativeBuildInputs = [
    pkg-config
    automake
    autoconf
  ];
  buildInputs = [
    bzip2
    libtar
    libtool
    autoconf-archive
    libxml2
    languageMachines.ticcutils
  ];
  preConfigure = "sh bootstrap.sh";

  meta = with lib; {
    description = "TiMBL implements several memory-based learning algorithms";
    mainProgram = "timbl";
    homepage = "https://github.com/LanguageMachines/timbl/";
    license = licenses.gpl3;
    platforms = platforms.all;
    maintainers = with maintainers; [ roberth ];

    longDescription = ''
      TiMBL is an open source software package implementing several memory-based learning algorithms, among which IB1-IG, an implementation of k-nearest neighbor classification with feature weighting suitable for symbolic feature spaces, and IGTree, a decision-tree approximation of IB1-IG. All implemented algorithms have in common that they store some representation of the training set explicitly in memory. During testing, new cases are classified by extrapolation from the most similar stored cases.

      For over fifteen years TiMBL has been mostly used in natural language processing as a machine learning classifier component, but its use extends to virtually any supervised machine learning domain. Due to its particular decision-tree-based implementation, TiMBL is in many cases far more efficient in classification than a standard k-nearest neighbor algorithm would be.
    '';
  };

}
