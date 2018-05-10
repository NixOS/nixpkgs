{stdenv, buildOcaml, fetchurl, type_conv}:

buildOcaml rec {
  name = "comparelib";
  version = "113.00.00";

  minimumSupportedOcamlVersion = "4.00";

  src = fetchurl {
    url = "https://github.com/janestreet/comparelib/archive/${version}.tar.gz";
    sha256 = "02l343drgi4200flfx73nzdk61zajwidsqjk9n80b2d37lvhazlf";
  };

  propagatedBuildInputs = [ type_conv ];

  meta = with stdenv.lib; {
    homepage = https://github.com/janestreet/comparelib;
    description = "Syntax extension for deriving \"compare\" functions automatically";
    license = licenses.asl20;
    maintainers = [ maintainers.ericbmerritt ];
  };
}
