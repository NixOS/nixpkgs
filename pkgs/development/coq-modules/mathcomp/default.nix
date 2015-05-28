{ stdenv, fetchurl, coq, ssreflect
, graphviz, ocaml, withDoc ? true
}:

stdenv.mkDerivation {

  name = "coq-mathcomp-1.5";

  src = fetchurl {
    url = http://ssr.msr-inria.inria.fr/FTP/mathcomp-1.5.tar.gz;
    sha256 = "1297svwi18blrlyd8vsqilar2h5nfixlvlifdkbx47aljq4m5bam";
  };

  nativeBuildInputs = stdenv.lib.optionals withDoc [ graphviz ocaml ];
  propagatedBuildInputs = [ coq ssreflect ];

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
    hydraPlatforms = [];
  };

}
