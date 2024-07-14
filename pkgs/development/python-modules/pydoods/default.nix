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
    hash = "sha256-fdhL30gmm5lv3ibDjck7kP6ATHxEURuFgzX5GKRjN68=";
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
