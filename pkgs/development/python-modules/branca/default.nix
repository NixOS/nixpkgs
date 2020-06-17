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
  version = "0.4.1";

  src = fetchPypi {
    inherit pname version;
    sha256 = "1f7drarwiw8fh17hpq8b3p4mfqgjbh3k045dvpx5z12d3a0zg7ca";
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
