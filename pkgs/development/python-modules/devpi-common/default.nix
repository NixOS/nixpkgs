{
  lib,
  buildPythonPackage,
  fetchPypi,
  pythonOlder,
  setuptools,
  setuptools-changelog-shortener,
  requests,
  tomli,
  pytestCheckHook,
  lazy,
}:

buildPythonPackage rec {
  pname = "devpi-common";
  version = "4.0.4";
  pyproject = true;

  disabled = pythonOlder "3.7";

  src = fetchPypi {
    pname = "devpi_common";
    inherit version;
    hash = "sha256-I1oKmkXJblTGC6a6L3fYVs+Q8aacG+6UmIfp7cA6Qcw=";
  };

  nativeBuildInputs = [
    setuptools
    setuptools-changelog-shortener
  ];

  propagatedBuildInputs = [
    requests
    lazy
    tomli
  ];

  nativeCheckInputs = [ pytestCheckHook ];

  pythonImportsCheck = [ "devpi_common" ];

  meta = with lib; {
    homepage = "https://github.com/devpi/devpi";
    description = "Utilities jointly used by devpi-server and devpi-client";
    changelog = "https://github.com/devpi/devpi/blob/common-${version}/common/CHANGELOG";
    license = licenses.mit;
    maintainers = with maintainers; [
      lewo
      makefu
    ];
  };
}
