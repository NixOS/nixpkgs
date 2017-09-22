{ stdenv, fetchFromGitHub, ocaml, findlib, jbuilder
, ppx_sexp_conv
, astring, ipaddr, uri
}:

stdenv.mkDerivation rec {
	version = "1.0.0";
	name = "ocaml${ocaml.version}-conduit-${version}";

	src = fetchFromGitHub {
		owner = "mirage";
		repo = "ocaml-conduit";
		rev = "v${version}";
		sha256 = "1ryigzh7sfif1mly624fpm87aw5h60n5wzdlrvqsf71qcpxc6iiz";
	};

	buildInputs = [ ocaml findlib jbuilder ppx_sexp_conv ];
	propagatedBuildInputs = [ astring ipaddr uri ];

	buildPhase = "jbuilder build -p conduit";

	inherit (jbuilder) installPhase;

	meta = {
		description = "Network connection library for TCP and SSL";
		license = stdenv.lib.licenses.isc;
		maintainers = [ stdenv.lib.maintainers.vbgl ];
		inherit (src.meta) homepage;
		inherit (ocaml.meta) platforms;
	};
}
