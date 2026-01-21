{
  lib,
  buildPythonPackage,
  fetchPypi,
  mypy-extensions,
  pytestCheckHook,
  pythonAtLeast,
  pytz,
  setuptools,
  typing-extensions,
}:

buildPythonPackage rec {
  pname = "logilab-common";
  version = "2.0.0";
  pyproject = true;

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-ojvR2k3Wpj5Ej0OS57I4aFX/cGFVeL/PmT7riCTelws=";
  };

  postPatch = lib.optionals (pythonAtLeast "3.12") ''
    substituteInPlace logilab/common/testlib.py \
      --replace-fail "_TextTestResult" "TextTestResult"
  '';

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
    changelog = "https://forge.extranet.logilab.fr/open-source/logilab-common/-/blob/branch/default/CHANGELOG.md";
    license = lib.licenses.lgpl21Plus;
    maintainers = [ ];
    mainProgram = "logilab-pytest";
  };
}
