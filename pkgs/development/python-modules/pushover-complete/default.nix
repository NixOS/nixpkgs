{
  lib,
  buildPythonPackage,
  fetchPypi,
  setuptools,
  requests,
  pytestCheckHook,
  requests-toolbelt,
  responses,
}:

buildPythonPackage rec {
  pname = "pushover-complete";
  version = "2.0.0";
  pyproject = true;

  src = fetchPypi {
    pname = "pushover_complete";
    inherit version;
    hash = "sha256-JPx9hNc0JoQOdnj+6A029A3wEUyzA1K6T5mrOELtIac=";
  };

  build-system = [ setuptools ];

  dependencies = [
    requests
  ];

  nativeCheckInputs = [
    pytestCheckHook
    requests-toolbelt
    responses
  ];

  pythonImportsCheck = [ "pushover_complete" ];

  meta = with lib; {
    description = "Python package for interacting with *all* aspects of the Pushover API";
    homepage = "https://github.com/scolby33/pushover_complete";
    license = licenses.mit;
    maintainers = [ maintainers.mic92 ];
  };
}
