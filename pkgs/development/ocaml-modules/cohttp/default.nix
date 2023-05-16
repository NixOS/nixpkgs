{ lib, fetchurl, buildDunePackage
, ppx_sexp_conv, base64, jsonm, re, stringext, uri-sexp
, ocaml, fmt, alcotest
, crowbar
}:

buildDunePackage rec {
  pname = "cohttp";
<<<<<<< HEAD
  version = "5.3.0";

  minimalOCamlVersion = "4.08";

  src = fetchurl {
    url = "https://github.com/mirage/ocaml-cohttp/releases/download/v${version}/cohttp-${version}.tbz";
    hash = "sha256-s72RxwTl6lEOkkuDqy7eH8RqLM5Eiw+M70iDuaFu7d0=";
  };

  postPatch = ''
    substituteInPlace cohttp/src/dune --replace 'bytes base64' 'base64'
  '';

=======
  version = "5.1.0";

  minimalOCamlVersion = "4.08";
  duneVersion = "3";

  src = fetchurl {
    url = "https://github.com/mirage/ocaml-cohttp/releases/download/v${version}/cohttp-v${version}.tbz";
    sha256 = "sha256-mINgeBO7DSsWd84gYjQNUQFqbh8KBZ+S2bYI/iVWMAc=";
  };

>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  buildInputs = [ jsonm ppx_sexp_conv ];

  propagatedBuildInputs = [ base64 re stringext uri-sexp ];

  doCheck = true;
  checkInputs = [ fmt alcotest crowbar ];

  meta = {
    description = "HTTP(S) library for Lwt, Async and Mirage";
    license = lib.licenses.isc;
    maintainers = [ lib.maintainers.vbgl ];
    homepage = "https://github.com/mirage/ocaml-cohttp";
  };
}
