{stdenv, fetchurl, ocaml, findlib, camomile, ounit}:

stdenv.mkDerivation {
  name = "ocaml-batteries-2.2.0";

  src = fetchurl {
    url = http://forge.ocamlcore.org/frs/download.php/1363/batteries-2.2.tar.gz;
    sha256 = "0z4wg357fzz7cnarjsrrdnpmxw8mxcj10fp67dm3bnn0l3zkjwbs";
  };

  buildInputs = [ocaml findlib camomile ounit];

  configurePhase = "true"; 	# Skip configure

  createFindlibDestdir = true;

  meta = {
    homepage = http://batteries.forge.ocamlcore.org/;
    description = "OCaml Batteries Included";
    longDescription = ''
      A community-driven effort to standardize on an consistent, documented,
      and comprehensive development platform for the OCaml programming
      language.
    '';
    license = stdenv.lib.licenses.lgpl21;
    platforms = ocaml.meta.platforms;
    maintainers = [
      stdenv.lib.maintainers.z77z
    ];
  };
}
