{ stdenv, fetchurl, coq, ncurses
, graphviz, withDoc ? true
, src, patches ? []
}:

stdenv.mkDerivation {

  name = "coq-ssreflect-1.5-${coq.coq-version}";

  inherit src;

  nativeBuildInputs = stdenv.lib.optionals withDoc [ graphviz ];
  buildInputs = [ coq.ocaml coq.camlp5 ncurses ];
  propagatedBuildInputs = [ coq ];

  enableParallelBuilding = true;

  inherit patches;

  postPatch = ''
    # Permit building of the ssrcoq statically-bound executable
    sed -i 's/^#-custom/-custom/' Make
    sed -i 's/^#SSRCOQ/SSRCOQ/' Make
  '';

  buildFlags = stdenv.lib.optionalString withDoc "doc";

  installFlags = "COQLIB=$(out)/lib/coq/${coq.coq-version}/";

  postInstall = ''
    mkdir -p $out/bin
    cp -p bin/ssrcoq $out/bin
    cp -p bin/ssrcoq.byte $out/bin
  '' + stdenv.lib.optionalString withDoc ''
    mkdir -p $out/share/doc/coq/${coq.coq-version}/user-contrib/Ssreflect/
    cp -r html $out/share/doc/coq/${coq.coq-version}/user-contrib/Ssreflect/
  '';

  meta = with stdenv.lib; {
    homepage = http://ssr.msr-inria.inria.fr/;
    license = licenses.cecill-b;
    maintainers = with maintainers; [ vbgl jwiegley ];
    platforms = coq.meta.platforms;
  };

}
