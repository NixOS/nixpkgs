{ stdenv, fetchFromGitHub, coq, bignums }:

stdenv.mkDerivation rec {

  name = "coq${coq.coq-version}-math-classes-${version}";
  version = "1.0.7";

  src = fetchFromGitHub {
    owner = "math-classes";
    repo = "math-classes";
    rev = version;
    sha256 = "0wgnczacvkb2pc3vjbni9bwjijfyd5jcdnyyjg8185hkf9zzabgi";
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
