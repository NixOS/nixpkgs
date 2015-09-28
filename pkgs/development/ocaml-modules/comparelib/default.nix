{stdenv, buildOcaml, fetchurl, type_conv}:

buildOcaml rec {
  name = "comparelib";
  version = "109.60.00";

  minimumSupportedOcamlVersion = "4.00";

  src = fetchurl {
    url = "https://github.com/janestreet/comparelib/archive/${version}.tar.gz";
    sha256 = "1075fb05e0d1e290f71ad0f6163f32b2cb4cebdc77568491c7eb38ba91f5db7e";
  };

  propagatedBuildInputs = [ type_conv ];

  meta = with stdenv.lib; {
    homepage = https://github.com/janestreet/comparelib;
    description = "Syntax extension for deriving \"compare\" functions automatically";
    license = licenses.asl20;
    maintainers = [ maintainers.ericbmerritt ];
  };
}
