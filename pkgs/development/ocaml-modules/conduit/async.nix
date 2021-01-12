{ lib, buildDunePackage, async, async_ssl, ppx_sexp_conv, conduit }:

if !lib.versionAtLeast conduit.version "1.0"
then conduit
else

buildDunePackage {
	pname = "conduit-async";
	useDune2 = true;
	inherit (conduit) version src;

	buildInputs = [ ppx_sexp_conv ];

	propagatedBuildInputs = [ async async_ssl conduit ];

	meta = conduit.meta // {
		description = "A network connection establishment library for Async";
	};
}
