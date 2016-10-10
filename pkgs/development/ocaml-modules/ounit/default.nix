{ stdenv, fetchurl, ocaml, findlib, ocamlbuild, camlp4 }:

stdenv.mkDerivation {
  name = "ounit-2.0.0";

  src = fetchurl {
    url = https://forge.ocamlcore.org/frs/download.php/1258/ounit-2.0.0.tar.gz;
    sha256 = "118xsadrx84pif9vaq13hv4yh22w9kmr0ypvhrs0viir1jr0ajjd";
  };

  buildInputs = [ ocaml findlib ocamlbuild camlp4 ];

  dontAddPrefix = true;

  doCheck = true;

  checkTarget = "test";

  createFindlibDestdir = true;

  meta = {
    homepage = http://ounit.forge.ocamlcore.org/;
    description = "Unit test framework for OCaml";
    license = stdenv.lib.licenses.mit;
    platforms = ocaml.meta.platforms or [];
    maintainers = [
      stdenv.lib.maintainers.z77z
    ];
  };
}
