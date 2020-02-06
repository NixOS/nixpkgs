{ stdenv, fetchFromGitHub, coq, bignums }:

stdenv.mkDerivation rec {

  name = "coq${coq.coq-version}-math-classes-${version}";
  version = "8.9.1";

  src = fetchFromGitHub {
    owner = "coq-community";
    repo = "math-classes";
    rev = version;
    sha256 = "1lw89js07m1wcaycpnyd85sf0snil2rrsfmry9lna2x66ah1mzn5";
  };

  buildInputs = [ coq bignums ];
  enableParallelBuilding = true;
  installFlags = [ "COQLIB=$(out)/lib/coq/${coq.coq-version}/" ];

  meta = with stdenv.lib; {
    homepage = https://math-classes.github.io;
    description = "A library of abstract interfaces for mathematical structures in Coq.";
    maintainers = with maintainers; [ siddharthist jwiegley ];
    platforms = coq.meta.platforms;
  };

  passthru = {
    compatibleCoqVersions = v: builtins.elem v [ "8.6" "8.7" "8.8" "8.9" "8.10" ];
  };

}
