{
  lib,
  mopidy,
  buildPythonPackage,
  fetchPypi,
  setuptools,
  uritools,
  pytestCheckHook,
}:

buildPythonPackage rec {
  pname = "mopidy-local";
  version = "3.3.0";
  pyproject = true;

  src = fetchPypi {
    inherit version;
    pname = "mopidy_local";
    hash = "sha256-y6btbGk5UiVan178x7d9jq5OTnKMbuliHv0aRxuZK3o=";
  };

  build-system = [
    setuptools
  ];

  dependencies = [
    mopidy
    uritools
  ];

  nativeCheckInputs = [
    pytestCheckHook
  ];

  pythonImportsCheck = [ "mopidy_local" ];

  meta = with lib; {
    homepage = "https://github.com/mopidy/mopidy-local";
    description = "Mopidy extension for playing music from your local music archive";
    license = licenses.asl20;
    maintainers = with maintainers; [ ruuda ];
  };
}
