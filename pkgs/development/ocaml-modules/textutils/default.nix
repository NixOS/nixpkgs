{stdenv, buildOcaml, fetchurl, core, pa_ounit, pa_test, sexplib}:

buildOcaml rec {
  name = "textutils";
  version = "112.17.00";

  minimalSupportedOcamlVersion = "4.02";

  src = fetchurl {
    url = "https://github.com/janestreet/textutils/archive/${version}.tar.gz";
    sha256 = "605d9fde66dc2d777721c936aa521e17169c143efaf9ff29619a7f273a7d0052";
  };

  buildInputs = [ pa_test ];
  propagatedBuildInputs = [ core pa_ounit sexplib ];

  meta = with stdenv.lib; {
    homepage = https://github.com/janestreet/textutils;
    description = "";
    license = stdenv.lib.licenses.asl20;
    maintainers = [ maintainers.ericbmerritt ];
  };
}
