{ lib
, buildPythonPackage
, fetchPypi
, requests
}:

buildPythonPackage rec {
  pname = "pyedimax";
  version = "0.2.1";
  format = "setuptools";

  src = fetchPypi {
    inherit pname version;
    sha256 = "1i3gr5vygqh2ryg67sl13aaql7nvf3nbybrg54628r4g7911b5rk";
  };

  propagatedBuildInputs = [ requests ];

  # Project has no tests
  doCheck = false;
  pythonImportsCheck = [ "pyedimax" ];

  meta = with lib; {
    description = "Python library for interfacing with the Edimax smart plugs";
    homepage = "https://github.com/andreipop2005/pyedimax";
    license = with licenses; [ mit ];
    maintainers = with maintainers; [ fab ];
  };
}
