{stdenv, fetchgit, coq}:

stdenv.mkDerivation rec {

  name = "coq-ext-lib-${coq.coq-version}-${version}";
  version = "c2c71a2a";

  src = fetchgit {
    url = git://github.com/coq-ext-lib/coq-ext-lib.git;
    rev = "c2c71a2a90ac87f2ceb311a6da53a6796b916816";
    sha256 = "01sihw3nmvvpc8viwyr01qnqifdcmlg016034xmrfmv863yp8c4g";
  };

  buildInputs = [ coq.ocaml coq.camlp5 ];
  propagatedBuildInputs = [ coq ];

  enableParallelBuilding = true;

  installFlags = "COQLIB=$(out)/lib/coq/${coq.coq-version}/";

  meta = with stdenv.lib; {
    homepage = https://github.com/coq-ext-lib/coq-ext-lib;
    description = "A collection of theories and plugins that may be useful in other Coq developments";
    maintainers = with maintainers; [ jwiegley ];
    platforms = coq.meta.platforms;
  };

}
