{ stdenv, buildDunePackage, cohttp-lwt
, conduit-lwt-unix, ppx_sexp_conv
, cmdliner, fmt, magic-mime
}:

if !stdenv.lib.versionAtLeast cohttp-lwt.version "0.99"
then cohttp-lwt
else

buildDunePackage {
	pname = "cohttp-lwt-unix";
	inherit (cohttp-lwt) version src meta;

	useDune2 = true;

	buildInputs = [ cmdliner ppx_sexp_conv ];

	propagatedBuildInputs = [ cohttp-lwt conduit-lwt-unix fmt magic-mime ];
}
