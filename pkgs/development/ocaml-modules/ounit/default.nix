{stdenv, fetchurl, ocaml, findlib, camlp4}:

let
  ocaml_version = (builtins.parseDrvName ocaml.name).version;
in

stdenv.mkDerivation {
  name = "ounit-2.0.0";

  src = fetchurl {
    url = https://forge.ocamlcore.org/frs/download.php/1258/ounit-2.0.0.tar.gz;
    sha256 = "118xsadrx84pif9vaq13hv4yh22w9kmr0ypvhrs0viir1jr0ajjd";
  };

  buildInputs = [ocaml findlib camlp4];

  dontAddPrefix = true;

  doCheck = true;

  checkTarget = "test";

  createFindlibDestdir = true;

  meta = {
    homepage = http://ounit.forge.ocamlcore.org/;
    description = "Unit test framework for OCaml";
    license = stdenv.lib.licenses.mit;
    platforms = ocaml.meta.platforms;
    hydraPlatforms = ocaml.meta.hydraPlatforms;
    maintainers = [
      stdenv.lib.maintainers.z77z
    ];
  };
}
