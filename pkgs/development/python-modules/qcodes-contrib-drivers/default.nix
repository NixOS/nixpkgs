{ lib
, fetchFromGitHub
, pythonOlder
, buildPythonPackage
, setuptools
, versioningit
, qcodes
, packaging
, pytestCheckHook
, pytest-mock
, pyvisa-sim
}:

buildPythonPackage rec {
  pname = "qcodes-contrib-drivers";
  version = "0.18.0";

  disabled = pythonOlder "3.8";
  format = "pyproject";

  src = fetchFromGitHub {
    owner = "QCoDeS";
    repo = "Qcodes_contrib_drivers";
    rev = "v${version}";
    sha256 = "sha256-hg3jSiuOkiuOInnUzzlKtBeoP5zkCDBQ3xP6KCwq+lU=";
  };

  nativeBuildInputs = [ setuptools versioningit ];

  propagatedBuildInputs = [
    qcodes
    packaging
  ];

  nativeCheckInputs = [
    pytestCheckHook
    pytest-mock
    pyvisa-sim
  ];

  pythonImportsCheck = [ "qcodes_contrib_drivers" ];

  # should be fixed starting with 0.19.0, remove at next release
  disabledTestPaths = [
    "qcodes_contrib_drivers/tests/test_Keysight_M3201A.py"
  ];

  postInstall = ''
    export HOME="$TMPDIR"
  '';

  meta = with lib; {
    description = "User contributed drivers for QCoDeS";
    homepage = "https://github.com/QCoDeS/Qcodes_contrib_drivers";
    license = licenses.mit;
    maintainers = with maintainers; [ evilmav ];
  };
}
