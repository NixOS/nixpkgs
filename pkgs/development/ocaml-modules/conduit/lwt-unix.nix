{ stdenv, buildDunePackage, conduit-lwt
, logs, ppx_sexp_conv, lwt_ssl
}:

if !stdenv.lib.versionAtLeast conduit-lwt.version "1.0"
then conduit-lwt
else

buildDunePackage {
	pname = "conduit-lwt-unix";
	inherit (conduit-lwt) version src meta;

	buildInputs = [ ppx_sexp_conv ];

	propagatedBuildInputs = [ conduit-lwt logs lwt_ssl ];
}
