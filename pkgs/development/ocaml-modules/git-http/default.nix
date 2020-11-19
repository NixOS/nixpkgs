{ buildDunePackage, git, cohttp, cohttp-lwt }:

buildDunePackage {
	pname = "git-http";
	inherit (git) version src minimumOCamlVersion;

	useDune2 = true;

	propagatedBuildInputs = [ git cohttp cohttp-lwt ];

	meta = {
		description = "Client implementation of the “Smart” HTTP Git protocol in pure OCaml";
		inherit (git.meta) homepage license maintainers;
	};
}
