{ stdenv, buildOcaml, fetchurl, ocaml, findlib, cmdliner, re, uri, fieldslib
, sexplib, conduit, stringext, base64, magic-mime, ounit, alcotest
, asyncSupport ? stdenv.lib.versionAtLeast ocaml.version "4.02"
, lwt ? null, async ? null, async_ssl ? null
}:

buildOcaml rec {
  name = "cohttp";
  version = "0.21.0";

  minimumSupportedOcamlVersion = "4.01";

  src = fetchurl {
    url = "https://github.com/mirage/ocaml-cohttp/archive/v${version}.tar.gz";
    sha256 = "09n45x5z2zb2f6nqa03fk056dbbvc5z5hk4yjk435ks7zhfbrqk5";
  };

  buildInputs = [ alcotest findlib cmdliner conduit magic-mime ounit ];
  propagatedBuildInputs = [ re stringext uri fieldslib sexplib base64 ]
    ++ stdenv.lib.optionals (asyncSupport && async != null && async_ssl != null) [ async async_ssl ]
    ++ stdenv.lib.optionals (lwt != null) [ lwt ];

  buildFlags = "PREFIX=$(out)";
  doCheck = true;
  checkTarget = "test";

  meta = with stdenv.lib; {
    homepage = https://github.com/mirage/ocaml-cohttp;
    description = "Very lightweight HTTP server using Lwt or Async";
    license = licenses.mit;
    maintainers = [ maintainers.ericbmerritt ];
  };
}
