{ lib
, buildPythonPackage
, fetchPypi
, pytestCheckHook
, pythonOlder
, hatch-jupyter-builder
, hatchling
, importlib-metadata
, ipywidgets
, jupyterlab
, psygnal
, typing-extensions
, watchfiles
}:

buildPythonPackage rec {
  pname = "anywidget";
  version = "0.6.3";
  format = "pyproject";

  disabled = pythonOlder "3.7";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-OUKxmYceEKURJeQTVI7oLT4SdZM90V7BoZf0UykkEV4=";
  };

  nativeBuildInputs = [
    hatch-jupyter-builder
    hatchling
    jupyterlab
  ];

  propagatedBuildInputs = [
    ipywidgets
    psygnal
    typing-extensions
  ] ++ lib.optional (pythonOlder "3.8") importlib-metadata;

  nativeCheckInputs = [
    pytestCheckHook
    watchfiles
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
