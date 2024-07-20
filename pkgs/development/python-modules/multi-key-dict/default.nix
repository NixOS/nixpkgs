{
  lib,
  buildPythonPackage,
  fetchPypi,
  setuptools,
}:

buildPythonPackage rec {
  pname = "multi-key-dict";
  version = "2.0.3";
  pyproject = true;

  src = fetchPypi {
    pname = "multi_key_dict";
    inherit version;
    hash = "sha256-3uvewXqjChxDLLP0N+gfhiHhwFQqDAYXp09x4jLpk54=";
  };

  nativeBuildInputs = [ setuptools ];

  # upstream has no tests
  doCheck = false;

  pythonImportsCheck = [ "multi_key_dict" ];

  meta = with lib; {
    description = "multi_key_dict";
    homepage = "https://github.com/formiaczek/multi_key_dict";
    license = licenses.mit;
  };
}
