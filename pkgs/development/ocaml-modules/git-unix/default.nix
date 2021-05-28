{ stdenv, buildDunePackage, git-http, cohttp, cohttp-lwt-unix
, mmap, cmdliner, mtime, alcotest, mirage-crypto-rng, tls
, io-page, git-binary
}:

buildDunePackage {
	pname = "git-unix";
	inherit (git-http) version src minimumOCamlVersion;

	useDune2 = true;

	propagatedBuildInputs = [ mmap cmdliner git-http cohttp cohttp-lwt-unix mtime ];
	checkInputs = [ alcotest mirage-crypto-rng tls io-page git-binary ];
	doCheck = !stdenv.isAarch64;

	meta = {
		description = "Unix backend for the Git protocol(s)";
		inherit (git-http.meta) homepage license maintainers;
	};
}
