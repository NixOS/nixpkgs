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
  version = "0.5.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-5vL366fdNozu+PY4Irhn9eEdTTq90Jmnh9ue0rcGWuE=";
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
