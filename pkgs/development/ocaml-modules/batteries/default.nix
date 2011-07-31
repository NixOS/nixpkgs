{stdenv, fetchurl, ocaml, findlib, camomile, ounit}:

let
  ocaml_version = (builtins.parseDrvName ocaml.name).version;
in

stdenv.mkDerivation {
  name = "ocaml-batteries-1.4.0";

  src = fetchurl {
    url = https://forge.ocamlcore.org/frs/download.php/643/batteries-1.4.0.tar.gz;
    sha256 = "1qyhiyanlhpbj0dv0vyqak87qfadjzg2pb8q93iybmg59akaxl15";
  };

  buildInputs = [ocaml findlib camomile ounit];

  patchPhase = ''
    substituteInPlace Makefile --replace '/bin/echo -n' echo
  '';

  configurePhase = "true"; 	# Skip configure

  preInstall = ''
    ensureDir "$out/lib/ocaml/${ocaml_version}/site-lib"
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
