{ buildDunePackage, git-http, cohttp-lwt-unix, tls, cmdliner, mtime }:

buildDunePackage rec {
	pname = "git-unix";
	inherit (git-http) version src;

	buildInputs = [ cmdliner mtime ];
	propagatedBuildInputs = [ cohttp-lwt-unix git-http tls ];

	meta = {
		description = "Unix backend for the Git protocol(s)";
		inherit (git-http.meta) homepage license maintainers;
	};
}
