{ stdenv, fetchFromGitHub, ocaml, findlib, astring, pprint }:

if !stdenv.lib.versionAtLeast ocaml.version "4.02"
then throw "ocp-ocamlres is not available for OCaml ${ocaml.version}"
else

stdenv.mkDerivation rec {
	name = "ocaml${ocaml.version}-ocp-ocamlres-${version}";
	version = "0.4";
	src = fetchFromGitHub {
		owner = "OCamlPro";
		repo = "ocp-ocamlres";
		rev = "v${version}";
		sha256 = "0smfwrj8qhzknhzawygxi0vgl2af4vyi652fkma59rzjpvscqrnn";
	};

	buildInputs = [ ocaml findlib astring pprint ];
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
