{
  lib,
  buildPythonPackage,
  fetchPypi,
  setuptools,
}:

buildPythonPackage rec {
  pname = "multi-key-dict";
  version = "2.0.4";
  pyproject = true;

  src = fetchPypi {
    pname = "multi_key_dict";
    inherit version;
    hash = "sha256-NLD+zkRcrgFH8NzVQikOyMq4OoAFNYkKa3xhXAx3nQg=";
  };

  nativeBuildInputs = [ setuptools ];

  # upstream has no tests
  doCheck = false;

  pythonImportsCheck = [ "multi_key_dict" ];

  meta = {
    description = "Multi_key_dict";
    homepage = "https://github.com/formiaczek/multi_key_dict";
    license = lib.licenses.mit;
  };
}
