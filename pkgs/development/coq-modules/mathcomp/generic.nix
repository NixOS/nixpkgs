{ stdenv, fetchurl, coq, ssreflect
, graphviz, ocamlPackages, withDoc ? true
, src
}:

stdenv.mkDerivation {

  name = "coq-mathcomp-1.5-${coq.coq-version}";

  inherit src;

  nativeBuildInputs = stdenv.lib.optionals withDoc
    ([ graphviz ] ++ (with ocamlPackages; [ ocaml camlp5_transitional ]));
  propagatedBuildInputs = [ ssreflect ];

  enableParallelBuilding = true;

  buildFlags = stdenv.lib.optionalString withDoc "doc";

  installFlags = "COQLIB=$(out)/lib/coq/${coq.coq-version}/";

  postInstall = stdenv.lib.optionalString withDoc ''
    make -f Makefile.coq install-doc DOCDIR=$out/share/coq/${coq.coq-version}/
  '';

  meta = with stdenv.lib; {
    homepage = http://ssr.msr-inria.inria.fr/;
    license = licenses.cecill-b;
    maintainers = [ maintainers.vbgl maintainers.jwiegley ];
    platforms = coq.meta.platforms;
  };

}
