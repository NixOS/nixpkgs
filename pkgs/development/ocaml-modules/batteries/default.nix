{stdenv, fetchurl, ocaml, findlib, camomile, ounit}:

let
  ocaml_version = (builtins.parseDrvName ocaml.name).version;
  version = "1.2.0";
in

stdenv.mkDerivation {
  name = "ocaml-batteries-${version}";

  src = fetchurl {
    url = "http://forge.ocamlcore.org/frs/download.php/423/batteries-${version}.tar.gz";
    sha256 = "0lkkbfj51zkhhr56nx167448pvg02nrzjjkl57ycic2ikzgq6lmx";
  };

  buildInputs = [ocaml findlib camomile ounit];

  configurePhase = "true"; 	# Skip configure

  doCheck = true;

  checkTarget = "test";

  meta = {
    homepage = http://batteries.forge.ocamlcore.org/;
    description = "OCaml Batteries Included";
    longDescription = ''
      A community-driven effort to standardize on an consistent, documented,
      and comprehensive development platform for the OCaml programming
      language.
    '';
    license = "LGPL";
  };
}
