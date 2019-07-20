{ stdenv, fetchFromGitHub, buildDunePackage, cstruct }:

buildDunePackage rec {
	pname = "mstruct";
	version = "1.4.0";

  minimumOCamlVersion = "4.02";

	src = fetchFromGitHub {
		owner = "mirage";
		repo = "ocaml-${pname}";
		rev = "v${version}";
		sha256 = "1p4ygwzs3n1fj4apfib0z0sabpph21bkq1dgjk4bsa59pq4prncm";
	};

	propagatedBuildInputs = [ cstruct ];

	meta = {
		description = "A thin mutable layer on top of cstruct";
		license = stdenv.lib.licenses.isc;
		maintainers = [ stdenv.lib.maintainers.vbgl ];
		inherit (src.meta) homepage;
	};
}
