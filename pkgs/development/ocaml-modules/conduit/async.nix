{ lib, buildDunePackage
, async, core, conduit, cstruct
, ke, fmt, bigstringaf, rresult
}:

if !lib.versionAtLeast conduit.version "1.0"
then conduit
else

buildDunePackage {
	pname = "conduit-async";
	inherit (conduit) version src useDune2;

	propagatedBuildInputs = [ core async conduit cstruct ];

	doCheck = true;
	checkInputs = [ ke fmt bigstringaf rresult ];

	meta = conduit.meta // {
		description = "A network connection establishment library for Async";
	};
}
