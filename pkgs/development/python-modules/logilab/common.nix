{
  lib,
  buildPythonPackage,
  fetchPypi,
  mypy-extensions,
  pytestCheckHook,
  pytz,
  setuptools,
  typing-extensions,
}:

buildPythonPackage rec {
  pname = "logilab-common";
  version = "2.1.0";
  pyproject = true;

  src = fetchPypi {
    pname = "logilab_common";
    inherit version;
    hash = "sha256-2GPHkd6gj85dPpMrrC8DwyK/wOuT1i1r+XTnZZ4r+34=";
  };

  build-system = [ setuptools ];

  dependencies = [
    setuptools
    mypy-extensions
    typing-extensions
  ];

  nativeCheckInputs = [
    pytestCheckHook
    pytz
  ];

  preCheck = ''
    export COLLECT_DEPRECATION_WARNINGS_PACKAGE_NAME=true
  '';

  meta = {
    description = "Python packages and modules used by Logilab";
    homepage = "https://logilab-common.readthedocs.io/";
    changelog = "https://forge.extranet.logilab.fr/open-source/logilab-common/-/blob/${version}/CHANGELOG.md";
    license = lib.licenses.lgpl21Plus;
    maintainers = [ ];
    mainProgram = "logilab-pytest";
  };
}
