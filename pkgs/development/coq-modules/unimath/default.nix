{stdenv, fetchgit, coq}:

stdenv.mkDerivation rec {

  name = "coq-unimath-${coq.coq-version}-${version}";
  version = "a2714eca";

  src = fetchgit {
    url = git://github.com/UniMath/UniMath.git;
    rev = "a2714eca29444a595cd280ea961ec33d17712009";
    sha256 = "0v7dlyipr6bhwgp9v366nxdan018acafh13pachnjkgzzpsjnr7g";
  };

  buildInputs = [ coq.ocaml coq.camlp5 ];
  propagatedBuildInputs = [ coq ];

  installFlags = "COQLIB=$(out)/lib/coq/${coq.coq-version}/";

  meta = with stdenv.lib; {
    homepage = https://github.com/UniMath/UniMath;
    description = "A formalization of a substantial body of mathematics using the univalent point of view";
    maintainers = with maintainers; [ jwiegley ];
    platforms = coq.meta.platforms;
  };

}
