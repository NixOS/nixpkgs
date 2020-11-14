{ buildDunePackage
, conduit, ocaml_lwt, cstruct
, ke, fmt, rresult, bigstringaf
}:

buildDunePackage {
	pname = "conduit-lwt";
	inherit (conduit) version src minimumOCamlVersion useDune2;

	propagatedBuildInputs = [ conduit cstruct ocaml_lwt ];

	doCheck = true;
	checkInputs = [ ke fmt rresult bigstringaf ];

	meta = conduit.meta // {
		description = "A network connection establishment library for Lwt";
	};
}
