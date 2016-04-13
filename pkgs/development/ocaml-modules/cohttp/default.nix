{stdenv, buildOcaml, fetchurl, cmdliner, re, uri, fieldslib, sexplib, conduit,
 stringext, base64, magic-mime, ounit, alcotest, lwt ? null,
 async ? null, async_ssl ? null}:

buildOcaml rec {
  name = "cohttp";
  version = "0.19.3";

  minimumSupportedOcamlVersion = "4.02";

  src = fetchurl {
    url = "https://github.com/mirage/ocaml-cohttp/archive/v${version}.tar.gz";
    sha256 = "1nrzpd4h52c1hnzcgsz462676saj9zss708ng001h54dglk8i1iv";
  };

  buildInputs = [ alcotest ];
  propagatedBuildInputs = [ cmdliner re uri fieldslib sexplib sexplib
                            conduit stringext base64 magic-mime ounit async
                            async_ssl lwt ];

  buildFlags = "PREFIX=$(out)";

  meta = with stdenv.lib; {
    homepage = https://github.com/mirage/ocaml-cohttp;
    description = "Very lightweight HTTP server using Lwt or Async";
    license = licenses.mit;
    maintainers = [ maintainers.ericbmerritt ];
  };
}
