{stdenv, fetchurl, ocaml}:

stdenv.mkDerivation {
  name = "ocaml-obuild-0.1.1";
  version = "0.1.1";

  src = fetchurl {
    url = "https://github.com/ocaml-obuild/obuild/archive/obuild-v0.1.1.tar.gz";
    sha256 = "19wbvkpfy2r0cl71c3i45z667n6i2jjyjxy8l5j6b4riqdvf39pw";
  };

  buildInputs = [ ocaml ];

  buildPhase = ''
    sh bootstrap
    '';

  installPhase = ''
    mkdir -p $out/bin
    install dist/build/obuild/obuild $out/bin
    install dist/build/obuild-simple/obuild-simple $out/bin
    install dist/build/obuild-from-oasis/obuild-from-oasis $out/bin
    '';

  meta = {
    homepage = https://github.com/vincenthz/obuild;
    description = "Simple build tool for OCaml programs";
    license = stdenv.lib.licenses.bsd2;
    maintainers = with stdenv.lib.maintainers; [ tstrobel ];
  };
}
