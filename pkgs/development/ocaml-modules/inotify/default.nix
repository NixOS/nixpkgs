{ stdenv, fetchFromGitHub, ocaml, findlib, ocamlbuild
, ocaml_lwt # optional lwt support
, doCheck ? stdenv.lib.versionAtLeast ocaml.version "4.03"
, ounit, fileutils # only for tests
}:

stdenv.mkDerivation rec {
	version = "2.3";
	name = "ocaml${ocaml.version}-inotify-${version}";

	src = fetchFromGitHub {
		owner = "whitequark";
		repo = "ocaml-inotify";
		rev = "v${version}";
		sha256 = "1s6vmqpx19hxzsi30jvp3h7p56rqnxfhfddpcls4nz8sqca1cz5y";
	};

	buildInputs = [ ocaml findlib ocamlbuild ocaml_lwt ]
	++ stdenv.lib.optionals doCheck [ ounit fileutils ];

	configureFlags = [ "--enable-lwt"
	  (stdenv.lib.optionalString doCheck "--enable-tests") ];

	inherit doCheck;
	checkTarget = "test";

	createFindlibDestdir = true;

	meta = {
		description = "Bindings for Linux’s filesystem monitoring interface, inotify";
		license = stdenv.lib.licenses.lgpl21;
		maintainers = [ stdenv.lib.maintainers.vbgl ];
		inherit (src.meta) homepage;
		platforms = stdenv.lib.platforms.linux;
	};
}
