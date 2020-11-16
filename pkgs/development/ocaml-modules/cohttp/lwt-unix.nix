{ lib, buildDunePackage, cohttp-lwt, cohttp-lwt-unix-nossl
, conduit-lwt, conduit-lwt-tls, ca-certs
, cmdliner, magic-mime, logs, fmt, ocaml_lwt
}:

if !lib.versionAtLeast cohttp-lwt.version "0.99"
then cohttp-lwt
else

buildDunePackage {
	pname = "cohttp-lwt-unix";
	inherit (cohttp-lwt) version src useDune2;

	minimumOCamlVersion = "4.08";

	propagatedBuildInputs = [
		cohttp-lwt cohttp-lwt-unix-nossl conduit-lwt conduit-lwt-tls ca-certs
		cmdliner magic-mime logs fmt ocaml_lwt
	];

	# requires system trust anchor not available in sandbox
	doCheck = false;

	meta = cohttp-lwt.meta // {
		description = "CoHTTP implementation for Unix and Windows using Lwt";
	};
}
