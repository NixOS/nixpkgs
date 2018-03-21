{stdenv, buildOcaml, fetchurl, ounit}:

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
