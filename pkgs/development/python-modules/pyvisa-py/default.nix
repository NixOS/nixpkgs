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
  version = "0.5.3";

  src = fetchFromGitHub {
    owner = "pyvisa";
    repo = "pyvisa-py";
    rev = "refs/tags/${version}";
    hash = "sha256-37GptqqBSIFOpm6SpS61ZZ9C4iU5AiOduVq255mTRNo=";
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
