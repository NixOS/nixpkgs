{
  lib,
  buildPythonPackage,
  click,
  fetchPypi,
  pytestCheckHook,
  pythonOlder,
  setuptools,
  six,
  versioneer,
}:

buildPythonPackage rec {
  pname = "click-spinner";
  version = "0.1.10";
  pyproject = true;

  disabled = pythonOlder "3.7";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-h+rPnXKYlzol12Fe9X1Hgq6/kTpTK7pLKKN+Nm6XXa8=";
  };

  postPatch = ''
    rm versioneer.py
  '';

  build-system = [
    setuptools
    versioneer
  ];

  nativeCheckInputs = [
    click
    pytestCheckHook
    six
  ];

  pythonImportsCheck = [ "click_spinner" ];

  meta = with lib; {
    description = "Add support for showwing that command line app is active to Click";
    homepage = "https://github.com/click-contrib/click-spinner";
    changelog = "https://github.com/click-contrib/click-spinner/releases/tag/v${version}";
    license = licenses.mit;
    maintainers = with maintainers; [ ];
  };
}
