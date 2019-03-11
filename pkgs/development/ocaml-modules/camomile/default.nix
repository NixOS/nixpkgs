{ stdenv, fetchFromGitHub, buildDunePackage, cppo }:

buildDunePackage rec {
  pname = "camomile";
	version = "1.0.1";

	src = fetchFromGitHub {
		owner = "yoriyuki";
		repo = pname;
		rev = version;
		sha256 = "1pfxr9kzkpd5bsdqrpxasfxkawwkg4cpx3m1h6203sxi7qv1z3fn";
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
