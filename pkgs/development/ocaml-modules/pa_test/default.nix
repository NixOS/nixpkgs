{stdenv, buildOcaml, fetchurl, type_conv, pa_ounit, sexplib_p4, herelib}:

buildOcaml rec {
  name = "pa_test";
  version = "112.24.00";

  minimumSupportedOcamlVersion = "4.00";

  src = fetchurl {
    url = "https://github.com/janestreet/pa_test/archive/${version}.tar.gz";
    sha256 = "b03d13c2bc9fa9a4b1c507d7108d965202160f83e9781d430d3b53a1993e30d6";
  };

  buildInputs = [ pa_ounit ];
  propagatedBuildInputs = [ type_conv sexplib_p4 herelib ];

  meta = with stdenv.lib; {
    homepage = https://github.com/janestreet/pa_test;
    description = "Syntax to reduce boiler plate in testing";
    license = licenses.asl20;
    maintainers = [ maintainers.ericbmerritt ];
  };
}
