{ stdenv, buildOcaml, fetchurl, ocaml, cmdliner, re, uri_p4, fieldslib_p4
, sexplib_p4, conduit , stringext, base64, magic-mime, ounit, alcotest
, asyncSupport ? stdenv.lib.versionAtLeast ocaml.version "4.02"
, lwt ? null, async_p4 ? null, async_ssl_p4 ? null
}:

buildOcaml rec {
  name = "cohttp";
  version = "0.19.3";

  minimumSupportedOcamlVersion = "4.01";

  src = fetchurl {
    url = "https://github.com/mirage/ocaml-cohttp/archive/v${version}.tar.gz";
    sha256 = "1nrzpd4h52c1hnzcgsz462676saj9zss708ng001h54dglk8i1iv";
  };

  buildInputs = [ alcotest cmdliner conduit magic-mime ounit lwt ]
  ++ stdenv.lib.optionals asyncSupport [ async_p4 async_ssl_p4 ];
  propagatedBuildInputs = [ re stringext uri_p4 fieldslib_p4 sexplib_p4 base64 ];

  buildFlags = [ "PREFIX=$(out)" ];

  meta = with stdenv.lib; {
    homepage = https://github.com/mirage/ocaml-cohttp;
    description = "Very lightweight HTTP server using Lwt or Async";
    license = licenses.mit;
    maintainers = [ maintainers.ericbmerritt ];
  };
}
