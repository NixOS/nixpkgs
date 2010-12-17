{stdenv, fetchurl, which, cryptopp, ocaml, findlib, ocaml_react, ocaml_ssl}:

let
  ocaml_version = (builtins.parseDrvName ocaml.name).version;
  version = "2.1.1";
in

stdenv.mkDerivation {
  name = "ocaml-lwt-${version}";

  src = fetchurl {
    url = "http://ocsigen.org/download/lwt-${version}.tar.gz";
    sha256 = "1zjn0sgihryshancn4kna1xslhc8gifliny1qd3a85f72xxxnw0w";
  };

  buildInputs = [which cryptopp ocaml findlib ocaml_react ocaml_ssl];

  configurePhase = "true";

  meta = {
    homepage = http://ocsigen.org/lwt;
    description = "Lightweight thread library for Objective Caml";
    license = "LGPL";
    platforms = ocaml.meta.platforms;
    maintainers = [
      stdenv.lib.maintainers.z77z
    ];
  };
}
