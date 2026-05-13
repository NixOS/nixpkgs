{
  lib,
  buildPythonPackage,
  fetchPypi,
  requests,
}:

buildPythonPackage rec {
  pname = "pydoods";
  version = "1.0.2";
  format = "setuptools";

  src = fetchPypi {
    inherit pname version;
    sha256 = "1brpcfj1iy9mhf2inla4gi681zlh7g4qvhr6vrprk6r693glpn3x";
  };

  propagatedBuildInputs = [ requests ];

  # Project has no tests
  doCheck = false;

  pythonImportsCheck = [ "pydoods" ];

  meta = {
    description = "Python wrapper for the DOODS service";
    homepage = "https://github.com/snowzach/pydoods";
    license = with lib.licenses; [ mit ];
    maintainers = with lib.maintainers; [ fab ];
  };
}
