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
  version = "0.3.1";

  src = fetchPypi {
    inherit pname version;
    sha256 = "3e762c9bdf40725f3d05ea1fda8fae9b470bfada6474e43a1242c8204a7bb15e";
  };

  checkInputs = [ pytest selenium ];
  propagatedBuildInputs = [ jinja2 six setuptools ];

  # Seems to require a browser
  doCheck = false;

  meta = {
    description = "Generate complex HTML+JS pages with Python";
    homepage = https://github.com/python-visualization/branca;
    license = with lib.licenses; [ mit ];
  };
}
