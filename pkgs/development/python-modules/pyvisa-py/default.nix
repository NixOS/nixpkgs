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
  version = "0.6.0";

  src = fetchFromGitHub {
    owner = "pyvisa";
    repo = "pyvisa-py";
    rev = "refs/tags/${version}";
    hash = "sha256-1EAkE2uYjo8sUbSrF6E1AGZkKPTxkSre3ov2RU8YhfM=";
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
