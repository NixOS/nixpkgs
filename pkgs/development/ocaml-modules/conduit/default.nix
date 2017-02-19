{ stdenv, buildOcaml, fetchurl, ocaml, sexplib, stringext, uri, cstruct, ipaddr
, ppx_driver, ppx_sexp_conv, ppx_optcomp, logs
, lwt ? null, async ? null, async_ssl ? null
}:

assert stdenv.lib.versionAtLeast ocaml.version "4.02.3";

buildOcaml rec {
  name = "conduit";
  version = "0.14.5";

  src = fetchurl {
    url = "https://github.com/mirage/ocaml-conduit/archive/v${version}.tar.gz";
    sha256 = "0vzqhck064v4cg3asa1db77qays5zpwwd43q5xqvnrjqq0rs7aq0";
  };

  buildInputs = [ ppx_sexp_conv ppx_driver ppx_optcomp ];
  propagatedBuildInputs = [ sexplib stringext uri cstruct ipaddr logs ]
                 ++ stdenv.lib.optional (async != null) async_ssl
                 ++ stdenv.lib.optional (async_ssl != null) async
                 ++ stdenv.lib.optional (lwt != null) lwt;

  meta = with stdenv.lib; {
    homepage = https://github.com/mirage/ocaml-conduit;
    description = "Resolve URIs into communication channels for Async or Lwt ";
    license = licenses.mit;
    maintainers = [ maintainers.ericbmerritt ];
  };
}
