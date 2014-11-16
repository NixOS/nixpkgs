{stdenv, fetchgit, coq}:

stdenv.mkDerivation rec {

  name = "coq-ynot-${coq.coq-version}-${version}";
  version = "ce1a9806";

  src = fetchgit {
    url = git://github.com/Ptival/ynot.git;
    rev = "ce1a9806c26ffc6e7def41da50a9aac1433cb2f8";
    sha256 = "1pcmcl5zamiimkcg1xvynxnfbv439y02vg1mnz79hqq9mnjyfnpw";
  };

  buildInputs = [ coq.ocaml coq.camlp5 ];
  propagatedBuildInputs = [ coq ];

  preBuild = "cd src";

  installPhase = ''
    COQLIB=$out/lib/coq/${coq.coq-version}/
    mkdir -p $COQLIB/user-contrib/Ynot
    cp -pR coq/*.vo $COQLIB/user-contrib/Ynot
  '';

  meta = with stdenv.lib; {
    homepage = http://ynot.cs.harvard.edu/;
    description = "Ynot is a library for writing and verifying imperative programs";
    maintainers = with maintainers; [ jwiegley ];
    platforms = coq.meta.platforms;
  };

}
