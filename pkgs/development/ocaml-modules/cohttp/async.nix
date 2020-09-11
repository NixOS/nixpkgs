{ stdenv, buildDunePackage, async, cohttp, conduit-async, uri, ppx_sexp_conv
, logs, magic-mime }:

if !stdenv.lib.versionAtLeast cohttp.version "0.99" then
	cohttp
else if !stdenv.lib.versionAtLeast async.version "0.13" then
	throw "cohttp-async needs async-0.13 (hence OCaml >= 4.08)"
else

	buildDunePackage {
		pname = "cohttp-async";
		useDune2 = true;
		inherit (cohttp) version src;

		buildInputs = [ ppx_sexp_conv ];

		propagatedBuildInputs = [ async cohttp conduit-async logs magic-mime uri ];

		meta = cohttp.meta // {
			description = "CoHTTP implementation for the Async concurrency library";
		};
	}
