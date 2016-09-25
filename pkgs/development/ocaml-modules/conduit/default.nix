{stdenv, buildOcaml, fetchurl, sexplib_p4, stringext, uri, cstruct, ipaddr,
 async ? null, async_ssl ? null, lwt ? null}:

buildOcaml rec {
  name = "conduit";
  version = "0.8.3";

  src = fetchurl {
    url = "https://github.com/mirage/ocaml-conduit/archive/v${version}.tar.gz";
    sha256 = "5cf1a46aa0254345e5143feebe6b54bdef96314e9987f44e69f24618d620faa1";
  };

  propagatedBuildInputs = ([ sexplib_p4 stringext uri cstruct ipaddr ]
                            ++ stdenv.lib.optional (lwt != null) lwt
                            ++ stdenv.lib.optional (async != null) async
                            ++ stdenv.lib.optional (async_ssl != null) async_ssl);

  meta = with stdenv.lib; {
    homepage = https://github.com/mirage/ocaml-conduit;
    description = "Resolve URIs into communication channels for Async or Lwt ";
    license = licenses.mit;
    maintainers = [ maintainers.ericbmerritt ];
  };
}
