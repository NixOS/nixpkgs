{ stdenv, buildOcaml, fetchurl, ocaml, sexplib_p4, stringext, uri_p4, cstruct, ipaddr_p4
, asyncSupport ? stdenv.lib.versionAtLeast ocaml.version "4.02"
, async_p4 ? null, async_ssl_p4 ? null, lwt ? null
}:

buildOcaml rec {
  name = "conduit";
  version = "0.10.0";

  src = fetchurl {
    url = "https://github.com/mirage/ocaml-conduit/archive/v${version}.tar.gz";
    sha256 = "1jz2skzsyg0axlkk9s6ahfblfrjx599wisyfs0cvn5dik9jqjadh";
  };

  propagatedBuildInputs = [ sexplib_p4 stringext uri_p4 cstruct ipaddr_p4 ];
  buildInputs = stdenv.lib.optional (lwt != null) lwt
             ++ stdenv.lib.optional (asyncSupport && async_p4 != null) async_p4
             ++ stdenv.lib.optional (asyncSupport && async_ssl_p4 != null) async_ssl_p4;

  meta = with stdenv.lib; {
    homepage = https://github.com/mirage/ocaml-conduit;
    description = "Resolve URIs into communication channels for Async or Lwt ";
    license = licenses.mit;
    maintainers = [ maintainers.ericbmerritt ];
  };
}
