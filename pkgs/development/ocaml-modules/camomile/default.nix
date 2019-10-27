{ stdenv, fetchFromGitHub, buildDunePackage, cppo }:

buildDunePackage rec {
  pname = "camomile";
	version = "1.0.2";

	src = fetchFromGitHub {
		owner = "yoriyuki";
		repo = pname;
		rev = version;
		sha256 = "00i910qjv6bpk0nkafp5fg97isqas0bwjf7m6rz11rsxilpalzad";
	};

	buildInputs = [ cppo ];

	configurePhase = "ocaml configure.ml --share $out/share/camomile";

	meta = {
		inherit (src.meta) homepage;
		maintainers = [ stdenv.lib.maintainers.vbgl ];
		license = stdenv.lib.licenses.lgpl21;
		description = "A Unicode library for OCaml";
	};
}
