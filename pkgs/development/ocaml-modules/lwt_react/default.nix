{ stdenv, fetchzip, ocaml, findlib, ocamlbuild, lwt, ocaml_react }:

stdenv.mkDerivation rec {
	version = "1.0.1";
	name = "ocaml${ocaml.version}-lwt_react-${version}";
	src = fetchzip {
		url = https://github.com/ocsigen/lwt/releases/download/3.0.0/lwt_react-1.0.1.tar.gz;
		sha256 = "1bbz7brvdskf4angzn3q2s2s6qdnx7x8m8syayysh23gwv4c7v31";
	};

	buildInputs = [ ocaml findlib ocamlbuild ];

	propagatedBuildInputs = [ lwt ocaml_react ];

	createFindlibDestdir = true;

	meta = {
		description = "Helpers for using React with Lwt";
		inherit (lwt.meta) homepage license maintainers platforms;
	};
}
