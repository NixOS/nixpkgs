{ buildDunePackage, git, cohttp-lwt, alcotest, mtime, nocrypto }:

buildDunePackage {
	pname = "git-http";
	inherit (git) version src;

	buildInputs = [ alcotest mtime nocrypto ];
	propagatedBuildInputs = [ git cohttp-lwt ];
	doCheck = true;

	meta = {
		description = "Client implementation of the “Smart” HTTP Git protocol in pure OCaml";
		inherit (git.meta) homepage license maintainers;
	};
}
