{ stdenv, fetchurl, coq, ssreflect, ncurses, which
, graphviz, ocamlPackages, withDoc ? false
, src
}:

stdenv.mkDerivation {

  name = "coq-mathcomp-1.6-${coq.coq-version}";

  inherit src;

  nativeBuildInputs = stdenv.lib.optionals withDoc [ graphviz ];
  buildInputs = [ coq.ocaml coq.camlp5 ncurses which ];
  propagatedBuildInputs = [ coq ssreflect ];

  enableParallelBuilding = true;

  buildFlags = stdenv.lib.optionalString withDoc "doc";

  preBuild = ''
    patchShebangs etc/utils/ssrcoqdep
    cd mathcomp
    export COQBIN=${coq}/bin/
  '';

  installPhase = ''
    make -f Makefile.coq COQLIB=$out/lib/coq/${coq.coq-version}/ install
    rm -fr $out/lib/coq/${coq.coq-version}/user-contrib/mathcomp/ssreflect*
    rm -fr $out/lib/coq/${coq.coq-version}/user-contrib/ssrmatching.cmi
    rm -fr $out/share/coq/${coq.coq-version}/user-contrib/mathcomp/ssreflect*
  '' + stdenv.lib.optionalString withDoc ''
    make -f Makefile.coq install-doc DOCDIR=$out/share/coq/${coq.coq-version}/
  '';

  meta = with stdenv.lib; {
    homepage = http://ssr.msr-inria.inria.fr/;
    license = licenses.cecill-b;
    maintainers = [ maintainers.vbgl maintainers.jwiegley ];
    platforms = coq.meta.platforms;
  };

}
