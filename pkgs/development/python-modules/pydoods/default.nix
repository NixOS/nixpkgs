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
    hash = "sha256-fdhL30gmm5lv3ibDjck7kP6ATHxEURuFgzX5GKRjN68=";
  };

  propagatedBuildInputs = [ requests ];

  # Project has no tests
  doCheck = false;

  pythonImportsCheck = [ "pydoods" ];

  meta = {
    description = "Python wrapper for the DOODS service";
    homepage = "https://github.com/snowzach/pydoods";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ fab ];
  };
}
