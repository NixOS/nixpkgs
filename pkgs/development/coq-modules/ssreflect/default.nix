{ stdenv, fetchurl, coq
, graphviz, withDoc ? true
}:

assert coq.coq-version == "8.4";

stdenv.mkDerivation {

  name = "coq-ssreflect-1.5";

  src = fetchurl {
    url = http://ssr.msr-inria.inria.fr/FTP/ssreflect-1.5.tar.gz;
    sha256 = "0hm1ha7sxqfqhc7iwhx6zdz3nki4rj5nfd3ab24hmz8v7mlpinds";
  };

  nativeBuildInputs = stdenv.lib.optionals withDoc [ graphviz ];
  buildInputs = [ coq.ocaml coq.camlp5 ];
  propagatedBuildInputs = [ coq ];

  enableParallelBuilding = true;

  patchPhase = ''
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
