{ stdenv, fetchFromGitHub, ocaml, dune, cppo, findlib }:

stdenv.mkDerivation rec {
  pname = "camomile";
	version = "1.0.1";

	src = fetchFromGitHub {
		owner = "yoriyuki";
		repo = pname;
		rev = version;
		sha256 = "1pfxr9kzkpd5bsdqrpxasfxkawwkg4cpx3m1h6203sxi7qv1z3fn";
	};

	buildInputs = [ ocaml dune findlib cppo ];

	configurePhase = "ocaml configure.ml --share $out/share/camomile";

  # Use jbuilder executable because it breaks on dune>=1.10
  # https://github.com/yoriyuki/Camomile/commit/505202b58e22628f80bbe15ee76b9470a5bd2f57#r33816944
  buildPhase = ''
    jbuilder build -p ${pname}
  '';

  inherit (dune) installPhase;

	meta = {
		inherit (src.meta) homepage;
		maintainers = [ stdenv.lib.maintainers.vbgl ];
		license = stdenv.lib.licenses.lgpl21;
		description = "A Unicode library for OCaml";
	};
}
