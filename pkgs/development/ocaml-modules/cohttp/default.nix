{ stdenv, fetchFromGitHub, ocaml, findlib, ocamlbuild
, ppx_fields_conv, ppx_sexp_conv
, base64, fieldslib, uri, conduit
# Optional for async and lwt support:
, async , async_ssl, cmdliner, fmt, magic-mime, ocaml_lwt, tls
}:

stdenv.mkDerivation rec {
	version = "0.22.0";
	name = "ocaml${ocaml.version}-cohttp-${version}";

	src = fetchFromGitHub {
		owner = "mirage";
		repo = "ocaml-cohttp";
		rev = "v${version}";
		sha256 = "1iy4ynh0yrw8337nsa9zvgcf476im0bhccsbs0vki3c5yxw2x60d";
	};

	buildInputs = [ ocaml findlib ocamlbuild ppx_fields_conv ppx_sexp_conv conduit
		async async_ssl cmdliner fmt magic-mime ocaml_lwt tls ];

	propagatedBuildInputs = [ base64 fieldslib uri ];

	makeFlags = [ "PREFIX=$(out)" ];

	createFindlibDestdir = true;

	meta = {
		description = "HTTP(S) library for Lwt, Async and Mirage";
		license = stdenv.lib.licenses.isc;
		maintainers = [ stdenv.lib.maintainers.vbgl ];
		inherit (src.meta) homepage;
		inherit (ocaml.meta) platforms;
	};
}
