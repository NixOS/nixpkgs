{ stdenv, fetchFromGitHub, coq, bignums }:

stdenv.mkDerivation rec {

  name = "coq${coq.coq-version}-math-classes-${version}";
  version = "8.8.1";

  src = fetchFromGitHub {
    owner = "coq-community";
    repo = "math-classes";
    rev = version;
    sha256 = "05vlrrwnlfhd7l3xwn4zwpnkwvziw84zpd9775c6ffb83z48ri1r";
  };

  buildInputs = [ coq bignums ];
  enableParallelBuilding = true;
  installFlags = "COQLIB=$(out)/lib/coq/${coq.coq-version}/";

  meta = with stdenv.lib; {
    homepage = https://math-classes.github.io;
    description = "A library of abstract interfaces for mathematical structures in Coq.";
    maintainers = with maintainers; [ siddharthist jwiegley ];
    platforms = coq.meta.platforms;
  };

  passthru = {
    compatibleCoqVersions = v: stdenv.lib.versionAtLeast v "8.6";
  };

}
