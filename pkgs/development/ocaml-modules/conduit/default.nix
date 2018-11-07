{ stdenv, fetchFromGitHub, buildDunePackage
, ppx_sexp_conv
, astring, ipaddr, uri
}:

buildDunePackage rec {
  pname = "conduit";
	version = "1.0.0";

	src = fetchFromGitHub {
		owner = "mirage";
		repo = "ocaml-conduit";
		rev = "v${version}";
		sha256 = "1ryigzh7sfif1mly624fpm87aw5h60n5wzdlrvqsf71qcpxc6iiz";
	};

	buildInputs = [ ppx_sexp_conv ];
	propagatedBuildInputs = [ astring ipaddr uri ];

	meta = {
		description = "Network connection library for TCP and SSL";
		license = stdenv.lib.licenses.isc;
		maintainers = [ stdenv.lib.maintainers.vbgl ];
		inherit (src.meta) homepage;
	};
}
