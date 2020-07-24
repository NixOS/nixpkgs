{ stdenv, buildDunePackage
, conduit-lwt, ppx_sexp_conv, ocaml_lwt, uri, ipaddr, ipaddr-sexp
, lwt_ssl, tls
}:

buildDunePackage {
	pname = "conduit-lwt-unix";
	inherit (conduit-lwt) version src minimumOCamlVersion;

	useDune2 = true;

	buildInputs = [ ppx_sexp_conv ];

	propagatedBuildInputs =
		[ conduit-lwt ocaml_lwt uri ipaddr ipaddr-sexp tls lwt_ssl ];

	meta = conduit-lwt.meta // {
		description = "A network connection establishment library for Lwt_unix";
	};
}
