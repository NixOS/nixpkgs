{ stdenv, fetchurl, coq, ncurses, which
, graphviz, withDoc ? false
, src, name
}:

stdenv.mkDerivation {

  inherit name;
  inherit src;

  nativeBuildInputs = stdenv.lib.optionals withDoc [ graphviz ];
  buildInputs = [ coq.ocaml coq.findlib coq.camlp5 ncurses which ];
  propagatedBuildInputs = [ coq ];

  enableParallelBuilding = true;

  buildFlags = stdenv.lib.optionalString withDoc "doc";

  preBuild = ''
    patchShebangs etc/utils/ssrcoqdep
    cd mathcomp
    export COQBIN=${coq}/bin/
  '';

  installPhase = ''
    make -f Makefile.coq COQLIB=$out/lib/coq/${coq.coq-version}/ install
  '' + stdenv.lib.optionalString withDoc ''
    make -f Makefile.coq install-doc DOCDIR=$out/share/coq/${coq.coq-version}/
  '';

  meta = with stdenv.lib; {
    homepage = http://ssr.msr-inria.inria.fr/;
    license = licenses.cecill-b;
    maintainers = [ maintainers.vbgl maintainers.jwiegley ];
    platforms = coq.meta.platforms;
  };

  passthru = {
    compatibleCoqVersions = v: builtins.elem v [ "8.5" "8.6" "8.7" ];
  };

}
