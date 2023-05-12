{ lib
, fetchFromGitHub
, buildPythonPackage
, setuptools-scm
, pyserial
, pyusb
, pyvisa
, typing-extensions
, pytestCheckHook
, pythonOlder
}:

buildPythonPackage rec {
  pname = "pyvisa-py";
  version = "0.7.0";
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "pyvisa";
    repo = "pyvisa-py";
    rev = "refs/tags/${version}";
    hash = "sha256-wMDO0CUCSSCB8cXvTmIEWD8OGMZRZNhmmRx+fZnK288=";
  };

  nativeBuildInputs = [
    setuptools-scm
  ];

  propagatedBuildInputs = [
    pyserial
    pyusb
    pyvisa
    typing-extensions
  ];

  nativeCheckInputs = [
    pytestCheckHook
  ];

  postConfigure = ''
    export SETUPTOOLS_SCM_PRETEND_VERSION="v${version}"
  '';

  meta = with lib; {
    description = "Module that implements the Virtual Instrument Software Architecture";
    homepage = "https://github.com/pyvisa/pyvisa-py";
    changelog = "https://github.com/pyvisa/pyvisa-py/blob/${version}/CHANGES";
    license = licenses.mit;
    maintainers = with maintainers; [ mvnetbiz ];
  };
}
