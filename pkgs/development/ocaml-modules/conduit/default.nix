{ stdenv, fetchFromGitHub, ocaml, findlib, ocamlbuild
, ppx_driver, ppx_sexp_conv
, ipaddr, uri, logs
, ocaml_lwt ? null
, async ? null, async_ssl ? null
, tls ? null
}:

stdenv.mkDerivation rec {
	version = "0.15.4";
	name = "ocaml${ocaml.version}-conduit-${version}";

	src = fetchFromGitHub {
		owner = "mirage";
		repo = "ocaml-conduit";
		rev = "v${version}";
		sha256 = "1ya7jqvhl8hc22cid5myf31w5c473imdxjnl9785lavsqj3djjxq";
	};

	buildInputs = [ ocaml findlib ocamlbuild ppx_driver ppx_sexp_conv
		ocaml_lwt async async_ssl tls ];
	propagatedBuildInputs = [ ipaddr uri logs ];

	createFindlibDestdir = true;

	meta = {
		description = "Network connection library for TCP and SSL";
		license = stdenv.lib.licenses.isc;
		maintainers = [ stdenv.lib.maintainers.vbgl ];
		inherit (src.meta) homepage;
		inherit (ocaml.meta) platforms;
	};
}
