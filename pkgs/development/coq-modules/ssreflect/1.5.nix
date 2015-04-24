{stdenv, fetchurl, coq}:

assert coq.coq-version == "8.5";

stdenv.mkDerivation {

  name = "coq-ssreflect-1.5-8.5b2";

  src = fetchurl {
    url = http://ssr.msr-inria.inria.fr/FTP/ssreflect-1.5.coq85beta2.tar.gz;
    sha256 = "084l9xd5vgb8jml0dkm66g8cil5rsf04w821pjhn2qk9mdbwaagf";
  };

  buildInputs = [ coq.ocaml coq.camlp5 ];
  propagatedBuildInputs = [ coq ];

  enableParallelBuilding = true;

  patches = [ ./threads.patch ];

  postPatch = ''
    # Permit building of the ssrcoq statically-bound executable
    sed -i 's/^#-custom/-custom/' Make
    sed -i 's/^#SSRCOQ/SSRCOQ/' Make
  '';

  installFlags = "COQLIB=$(out)/lib/coq/${coq.coq-version}/";

  postInstall = ''
    mkdir -p $out/bin
    cp -p bin/ssrcoq $out/bin
    cp -p bin/ssrcoq.byte $out/bin
  '';

  meta = with stdenv.lib; {
    homepage = http://ssr.msr-inria.inria.fr/;
    license = licenses.cecill-b;
    maintainers = with maintainers; [ vbgl jwiegley ];
    platforms = coq.meta.platforms;
  };

}
