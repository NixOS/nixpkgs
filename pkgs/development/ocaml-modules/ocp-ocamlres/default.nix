{ stdenv, fetchFromGitHub, ocaml, findlib, pprint }:

stdenv.mkDerivation rec {
	name = "ocaml${ocaml.version}-ocp-ocamlres-${version}";
	version = "0.3";
	src = fetchFromGitHub {
		owner = "OCamlPro";
		repo = "ocp-ocamlres";
		rev = "v${version}";
		sha256 = "0pm1g38f6pmch1x4pcc09ky587x5g7p7n9dfbbif8zkjqr603ixg";
	};

	buildInputs = [ ocaml findlib pprint ];
	createFindlibDestdir = true;

	installFlags = [ "BINDIR=$(out)/bin" ];
	preInstall = "mkdir -p $out/bin";

	meta = {
		description = "A simple tool and library to embed files and directories inside OCaml executables";
		license = stdenv.lib.licenses.lgpl3Plus;
		homepage = https://www.typerex.org/ocp-ocamlres.html;
		maintainers = [ stdenv.lib.maintainers.vbgl ];
		inherit (ocaml.meta) platforms;
	};
}
