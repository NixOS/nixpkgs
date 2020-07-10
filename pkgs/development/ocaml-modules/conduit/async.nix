{ stdenv, buildDunePackage, async, ppx_sexp_conv, conduit }:

if !stdenv.lib.versionAtLeast conduit.version "1.0"
then conduit
else

buildDunePackage {
	pname = "conduit-async";
	inherit (conduit) version src;

	buildInputs = [ ppx_sexp_conv ];

	propagatedBuildInputs = [ async conduit ];

	meta = conduit.meta // {
		description = "A network connection establishment library for Async";
	};
}
