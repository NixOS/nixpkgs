{stdenv, fetchurl, ocaml, findlib, camomile, ounit}:

let
  ocaml_version = (builtins.parseDrvName ocaml.name).version;
in

stdenv.mkDerivation {
  name = "ocaml-batteries-1.3.0";

  src = fetchurl {
    url = "https://forge.ocamlcore.org/frs/download.php/560/batteries-1.3.0.tar.gz";
    sha256 = "1kf8dyivigavi89lpsz7hzdv48as10yck7gkmqmnsnn1dps3m7an";
  };

  buildInputs = [ocaml findlib camomile ounit];

  # This option is not correctly detected on Darwin
  # It should be fixed in the svn
  BATTERIES_NATIVE_SHLIB = if stdenv.isDarwin then "no" else "yes";

  # Ditto
  patchPhase = ''
    substituteInPlace Makefile --replace 'echo -n' echo
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
