{
  lib,
  buildPythonPackage,
  fetchPypi,
  mock,
  pytestCheckHook,
  pythonOlder,
  pythonRelaxDepsHook,
  setuptools,
}:

buildPythonPackage rec {
  pname = "schema";
  version = "0.7.7";
  pyproject = true;

  disabled = pythonOlder "3.6";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-faVTq9KVihncJUfDiM3lM5izkZYXWpvlnqHK9asKGAc=";
  };

  pythonRemoveDeps = [ "contextlib2" ];

  build-system = [ setuptools ];

  nativeBuildInputs = [ pythonRelaxDepsHook ];

  nativeCheckInputs = [
    mock
    pytestCheckHook
  ];

  pythonImportsCheck = [ "schema" ];

  meta = with lib; {
    description = "Library for validating Python data structures";
    homepage = "https://github.com/keleshev/schema";
    changelog = "https://github.com/keleshev/schema/blob/v${version}/CHANGELOG.md";
    license = licenses.mit;
    maintainers = with maintainers; [ tobim ];
  };
}
