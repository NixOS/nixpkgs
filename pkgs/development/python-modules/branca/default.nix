{ lib
, buildPythonPackage
, fetchPypi
, pytest
, jinja2
, selenium
, six
, setuptools
}:

buildPythonPackage rec {
  pname = "branca";
  version = "0.4.2";

  src = fetchPypi {
    inherit pname version;
    sha256 = "c111453617b17ab2bda60a4cd71787d6f2b59c85cdf71ab160a737606ac66c31";
  };

  checkInputs = [ pytest selenium ];
  propagatedBuildInputs = [ jinja2 six setuptools ];

  # Seems to require a browser
  doCheck = false;

  meta = {
    description = "Generate complex HTML+JS pages with Python";
    homepage = "https://github.com/python-visualization/branca";
    license = with lib.licenses; [ mit ];
  };
}
