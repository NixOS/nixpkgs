{ lib
, buildPythonPackage
, fetchPypi
, pytest
, jinja2
, selenium
}:

buildPythonPackage rec {
  pname = "branca";
  version = "0.2.0";
  name = "${pname}-${version}";

  src = fetchPypi {
    inherit pname version;
    sha256 = "327b0bae73a519f25dc2f320d8d9f1885aad2e8e5105add1496269d5391b8ea4";
  };

  checkInputs = [ pytest selenium ];
  propagatedBuildInputs = [ jinja2 ];

  # Seems to require a browser
  doCheck = false;

  meta = {
    description = "Generate complex HTML+JS pages with Python";
    homepage = https://github.com/python-visualization/branca;
    license = with lib.licenses; [ mit ];
  };
}
