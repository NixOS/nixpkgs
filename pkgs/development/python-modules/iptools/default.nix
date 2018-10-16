{ stdenv
, buildPythonPackage
, fetchPypi
, nose
}:

buildPythonPackage rec {
  version = "0.6.1";
  pname = "iptools";

  src = fetchPypi {
    inherit pname version;
    sha256 = "0f03875a5bed740ba4bf44decb6a78679cca914a1ee8a6cc468114485c4d98e3";
  };

  buildInputs = [ nose ];

  meta = with stdenv.lib; {
    description = "Utilities for manipulating IP addresses including a class that can be used to include CIDR network blocks in Django's INTERNAL_IPS setting";
    homepage = https://pypi.python.org/pypi/iptools;
    license = licenses.bsd0;
  };

}
