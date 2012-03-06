{stdenv, fetchurl, ocaml, findlib, camomile, ounit}:

let
  ocaml_version = (builtins.parseDrvName ocaml.name).version;
in

stdenv.mkDerivation {
  name = "ocaml-batteries-1.4.1";

  src = fetchurl {
    url = http://forge.ocamlcore.org/frs/download.php/684/batteries-1.4.1.tar.gz;
    sha256 = "bdca7deba290d83c66c0a5001da52b2d7f2af58b7b7e7d9303d4363aaafe9c30";
  };

  buildInputs = [ocaml findlib camomile ounit];

  patchPhase = ''
    substituteInPlace Makefile --replace '/bin/echo -n' echo
  '';

  configurePhase = "true"; 	# Skip configure

  preInstall = ''
    mkdir -p "$out/lib/ocaml/${ocaml_version}/site-lib"
  '';

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
    platforms = ocaml.meta.platforms;
    maintainers = [
      stdenv.lib.maintainers.z77z
    ];
  };
}
