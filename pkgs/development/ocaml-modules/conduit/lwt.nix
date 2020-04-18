{ stdenv, buildDunePackage, ppx_sexp_conv, conduit, ocaml_lwt }:

if !stdenv.lib.versionAtLeast conduit.version "1.0"
then conduit
else

buildDunePackage {
	pname = "conduit-lwt";
	inherit (conduit) version src meta;

	buildInputs = [ ppx_sexp_conv ];

	propagatedBuildInputs = [ conduit ocaml_lwt ];
}
