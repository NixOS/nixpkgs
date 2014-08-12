{ stdenv, fetchurl, coq, ocaml, ocamlPackages, gcc }:

stdenv.mkDerivation rec {
  name    = "compcert-${version}";
  version = "2.3pl2";

  src = fetchurl {
    url    = "http://compcert.inria.fr/release/${name}.tgz";
    sha256 = "1cq4my646ll1mszs5mbzwk4vp8l8qnsc96fpcv2pl35aw5i6jqm8";
  };

  buildInputs = [ coq ocaml ocamlPackages.menhir ];

  enableParallelBuilding = true;
  configurePhase = "./configure -prefix $out -toolprefix ${gcc}/bin/ " +
    (if stdenv.isDarwin then "ia32-macosx" else "ia32-linux");

  meta = {
    description = "Formally verified C compiler";
    homepage    = "http://compcert.inria.fr";
    license     = stdenv.lib.licenses.inria;
    platforms   = stdenv.lib.platforms.linux ++
                  stdenv.lib.platforms.darwin;
    maintainers = [ stdenv.lib.maintainers.thoughtpolice
                    stdenv.lib.maintainers.jwiegley ];
  };
}
