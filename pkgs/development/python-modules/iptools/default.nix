{
  lib,
  buildPythonPackage,
  fetchPypi,
  nose,
}:

buildPythonPackage rec {
  version = "0.7.0";
  format = "setuptools";
  pname = "iptools";

  src = fetchPypi {
    inherit pname version;
    sha256 = "1sp2v76qqsgqjk0vqfbm2s4sc4mi0gkkpzjnvwih3ymmidilz2hi";
  };

  buildInputs = [ nose ];

  meta = with lib; {
    description = "Utilities for manipulating IP addresses including a class that can be used to include CIDR network blocks in Django's INTERNAL_IPS setting";
    homepage = "https://pypi.python.org/pypi/iptools";
    license = licenses.bsd0;
  };
}
