{ stdenv, fetchurl, coq, ocaml, gcc }:

stdenv.mkDerivation rec {
  name    = "compcert-${version}";
  version = "2.3pl2";

  src = fetchurl {
    url    = "http://compcert.inria.fr/release/${name}.tgz";
    sha256 = "1cq4my646ll1mszs5mbzwk4vp8l8qnsc96fpcv2pl35aw5i6jqm8";
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
