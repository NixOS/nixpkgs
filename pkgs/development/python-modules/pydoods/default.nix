{
  lib,
  buildPythonPackage,
  fetchPypi,
  pythonOlder,
  requests,
}:

buildPythonPackage rec {
  pname = "pydoods";
  version = "1.0.2";
  format = "setuptools";

  disabled = pythonOlder "3.6";

  src = fetchPypi {
    inherit pname version;
    sha256 = "1brpcfj1iy9mhf2inla4gi681zlh7g4qvhr6vrprk6r693glpn3x";
  };

  propagatedBuildInputs = [ requests ];

  # Project has no tests
  doCheck = false;

  pythonImportsCheck = [ "pydoods" ];

  meta = with lib; {
    description = "Python wrapper for the DOODS service";
    homepage = "https://github.com/snowzach/pydoods";
    license = with licenses; [ mit ];
    maintainers = with maintainers; [ fab ];
  };
}
