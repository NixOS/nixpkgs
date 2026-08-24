{
  lib,
  buildPythonPackage,
  click,
  fetchPypi,
  pytestCheckHook,
  setuptools,
  six,
  versioneer,
}:

buildPythonPackage rec {
  pname = "click-spinner";
  version = "0.2.0";
  pyproject = true;

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-ATcVUFlrwY8eFUa7KVZ0Xu04cjUjXmZLyW+MxnW31ug=";
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

  meta = {
    description = "Add support for showwing that command line app is active to Click";
    homepage = "https://github.com/click-contrib/click-spinner";
    changelog = "https://github.com/click-contrib/click-spinner/releases/tag/v${version}";
    license = lib.licenses.mit;
    maintainers = [ ];
  };
}
