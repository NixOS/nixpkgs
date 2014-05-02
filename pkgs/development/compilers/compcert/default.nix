{ stdenv, fetchurl, coq, ocaml, gcc }:

stdenv.mkDerivation rec {
  name    = "compcert-${version}";
  version = "2.2";

  src = fetchurl {
    url    = "http://compcert.inria.fr/release/${name}.tgz";
    sha256 = "0zhqx9mixlsycckl6wq6yrd795byj1jz7m4njcgfv29cx33j1nrk";
  };

  buildInputs = [ coq ocaml ];

  enableParallelBuilding = true;
  configurePhase = "./configure -prefix $out -toolprefix ${gcc}/bin/ ia32-linux";

  meta = {
    description = "Formally verified C compiler";
    homepage    = "http://compcert.inria.fr";
    license     = stdenv.lib.licenses.inria;
    platforms   = [ "i686-linux" ];
    maintainers = [ stdenv.lib.maintainers.thoughtpolice ];
  };
}
