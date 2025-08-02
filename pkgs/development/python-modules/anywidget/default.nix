{
  lib,
  buildPythonPackage,
  fetchPypi,
  pytestCheckHook,
  writableTmpDirAsHomeHook,
  pythonOlder,
  hatch-jupyter-builder,
  hatchling,
  importlib-metadata,
  ipykernel,
  ipywidgets,
  psygnal,
  pydantic,
  typing-extensions,
  watchfiles,
}:

buildPythonPackage rec {
  pname = "anywidget";
  version = "0.9.18";
  pyproject = true;

  disabled = pythonOlder "3.7";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-Jiz0WbUXp9BE1vvIS5U+nIPwJnkLLdPOkPIaf47e0A8=";
  };

  build-system = [
    hatch-jupyter-builder
    hatchling
  ];

  dependencies = [
    ipywidgets
    psygnal
    typing-extensions
  ]
  ++ lib.optional (pythonOlder "3.8") importlib-metadata;

  nativeCheckInputs = [
    pytestCheckHook
    ipykernel
    pydantic
    watchfiles
    writableTmpDirAsHomeHook
  ];

  disabledTests = [
    # requires package.json
    "test_version"
  ];

  pythonImportsCheck = [ "anywidget" ];

  meta = with lib; {
    description = "Custom jupyter widgets made easy";
    homepage = "https://github.com/manzt/anywidget";
    changelog = "https://github.com/manzt/anywidget/releases/tag/anywidget%40${version}";
    license = licenses.mit;
    maintainers = with maintainers; [ natsukium ];
  };
}
