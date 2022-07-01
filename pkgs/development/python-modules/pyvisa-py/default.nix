{ lib
, fetchFromGitHub
, buildPythonPackage
, setuptools-scm
, pyserial
, pyusb
, pyvisa
, typing-extensions
, pytestCheckHook
}:

buildPythonPackage rec {
  pname = "pyvisa-py";
  version = "0.5.1";

  src = fetchFromGitHub {
    owner = "pyvisa";
    repo = "pyvisa-py";
    rev = version;
    hash = "sha256-V1BS+BvHVI8h/rynLnOHvQdIR6RwQrNa2p2S6GQug98=";
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

  checkInputs = [
    pytestCheckHook
  ];

  postConfigure = ''
    export SETUPTOOLS_SCM_PRETEND_VERSION="v${version}"
  '';

  meta = with lib; {
    description = "PyVISA backend that implements a large part of the Virtual Instrument Software Architecture in pure Python";
    homepage = "https://github.com/pyvisa/pyvisa-py";
    license = licenses.mit;
    maintainers = with maintainers; [ mvnetbiz ];
  };
}
