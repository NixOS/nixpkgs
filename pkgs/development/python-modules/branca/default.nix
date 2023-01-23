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
  version = "0.6.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-VZSYVSFFBMdYO3G5oDqE3OLpaoQCdhO7U7QtBIRM4k4=";
  };

  nativeCheckInputs = [ pytest selenium ];
  propagatedBuildInputs = [ jinja2 six setuptools ];

  # Seems to require a browser
  doCheck = false;

  meta = {
    description = "Generate complex HTML+JS pages with Python";
    homepage = "https://github.com/python-visualization/branca";
    license = with lib.licenses; [ mit ];
  };
}
