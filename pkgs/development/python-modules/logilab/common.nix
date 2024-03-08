{ lib
, buildPythonPackage
, fetchPypi
, pythonOlder
, setuptools
, importlib-metadata
, mypy-extensions
, typing-extensions
, pytestCheckHook
, pytz
}:

buildPythonPackage rec {
  pname = "logilab-common";
  version = "2.0.0";
  format = "pyproject";

  disabled = pythonOlder "3.6";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-ojvR2k3Wpj5Ej0OS57I4aFX/cGFVeL/PmT7riCTelws=";
  };

  nativeBuildInputs = [
    setuptools
  ];

  propagatedBuildInputs = [
    setuptools
    mypy-extensions
    typing-extensions
  ] ++ lib.optionals (pythonOlder "3.8") [
    importlib-metadata
  ];

  nativeCheckInputs = [
    pytestCheckHook
    pytz
  ];

  preCheck = ''
    export COLLECT_DEPRECATION_WARNINGS_PACKAGE_NAME=true
  '';

  meta = with lib; {
    description = "Python packages and modules used by Logilab ";
    homepage = "https://logilab-common.readthedocs.io/";
    changelog = "https://forge.extranet.logilab.fr/open-source/logilab-common/-/blob/branch/default/CHANGELOG.md";
    license = licenses.lgpl21Plus;
  };
}
