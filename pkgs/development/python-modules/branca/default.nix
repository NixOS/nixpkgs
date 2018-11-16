{ lib
, buildPythonPackage
, fetchPypi
, pytest
, jinja2
, selenium
}:

buildPythonPackage rec {
  pname = "branca";
  version = "0.3.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "bea38396cf58fd7173ac942277fe4138127eb1546622684206cb34d344b03fb4";
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
