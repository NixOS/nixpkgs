{ stdenv, fetchurl, coq, ncurses, which
, graphviz, withDoc ? false
, src, name, patches ? []
}:

stdenv.mkDerivation {

  inherit name;
  inherit src;

  nativeBuildInputs = stdenv.lib.optionals withDoc [ graphviz ];
  buildInputs = [ coq.ocaml coq.findlib coq.camlp5 ncurses which ];
  propagatedBuildInputs = [ coq ];

  enableParallelBuilding = true;

  inherit patches;

  preBuild = ''
    patchShebangs etc/utils/ssrcoqdep
    cd mathcomp/ssreflect
    export COQBIN=${coq}/bin/
  '';

  installPhase = ''
    make -f Makefile.coq COQLIB=$out/lib/coq/${coq.coq-version}/ install
  '';

  postInstall = ''
    # mkdir -p $out/bin
    # cp -p bin/ssrcoq $out/bin
    # cp -p bin/ssrcoq.byte $out/bin
  '' + stdenv.lib.optionalString withDoc ''
    mkdir -p $out/share/doc/coq/${coq.coq-version}/user-contrib/mathcomp/ssreflect/
    cp -r html $out/share/doc/coq/${coq.coq-version}/user-contrib/mathcomp/ssreflect/
  '';

  meta = with stdenv.lib; {
    homepage = http://ssr.msr-inria.inria.fr/;
    license = licenses.cecill-b;
    maintainers = with maintainers; [ vbgl jwiegley ];
    platforms = coq.meta.platforms;
  };

  passthru = {
    compatibleCoqVersions = v: builtins.elem v [ "8.5" "8.6" "8.7" ];
  };

}
