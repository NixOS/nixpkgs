{ stdenv, fetchgit, coq, mathcomp }:

stdenv.mkDerivation rec {

  name = "coq-coqeal-${coq.coq-version}-${version}";
  version = "7522037d";

  src = fetchgit {
    url = git://github.com/CoqEAL/CoqEAL.git;
    rev = "7522037d5e01e651e705d782f4f91fc68c46866e";
    sha256 = "0kbnsrycd0hjni311i8xc5xinn4ia8rnqi328sdfqzvvyky37fgj";
  };

  propagatedBuildInputs = [ mathcomp ];

  preConfigure = ''
    cd theory
    patch ./Make <<EOF
    0a1
    > -R . CoqEAL
    EOF
  '';

  installFlags = "COQLIB=$(out)/lib/coq/${coq.coq-version}/";

  meta = with stdenv.lib; {
    homepage = http://www.maximedenes.fr/content/coqeal-coq-effective-algebra-library;
    description = "A Coq library for effective algebra, by which is meant formally verified computer algebra algorithms that can be run inside Coq on concrete inputs";
    maintainers = with maintainers; [ jwiegley ];
    platforms = coq.meta.platforms;
  };

}
