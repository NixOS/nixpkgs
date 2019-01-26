{ stdenv, buildOcaml, ocaml, fetchurl, ounit }:

if stdenv.lib.versionAtLeast ocaml.version "4.06"
then throw "pa_ounit is not available for OCaml ${ocaml.version}"
else

buildOcaml rec {
  name = "pa_ounit";
  version = "113.00.00";

  src = fetchurl {
    url = "https://github.com/janestreet/pa_ounit/archive/${version}.tar.gz";
    sha256 = "0vi0p2hxcrdsl0319c9s8mh9hmk2i4ir6c6vrj8axkc37zkgc437";
  };

  propagatedBuildInputs = [ ounit ];

  meta = with stdenv.lib; {
    homepage = https://github.com/janestreet/pa_ounit;
    description = "OCaml inline testing";
    license = licenses.asl20;
    maintainers = [ maintainers.ericbmerritt ];
  };
}
