{ lib
, fetchFromGitHub
, buildPythonPackage
, setuptools-scm
, setuptools
, typing-extensions
, pytestCheckHook
}:

buildPythonPackage rec {
  pname = "pyvisa";
  version = "1.11.3";

  src = fetchFromGitHub {
    owner = "pyvisa";
    repo = "pyvisa";
    rev = version;
    hash = "sha256-Qe7W1zPI1aedLDnhkLTDPTa/lsNnCGik5Hu+jLn+meA=";
  };

  nativeBuildInputs = [
    setuptools-scm
  ];

  propagatedBuildInputs = [
    typing-extensions
    setuptools
  ];

  checkInputs = [
    pytestCheckHook
  ];

  # Test can't find cli tool bin path correctly
  disabledTests = [
    "test_visa_info"
  ];

  postConfigure = ''
    export SETUPTOOLS_SCM_PRETEND_VERSION="v${version}"
  '';

  meta = with lib; {
    description = "Python package for support of the Virtual Instrument Software Architecture (VISA)";
    homepage = "https://github.com/pyvisa/pyvisa";
    license = licenses.mit;
    maintainers = with maintainers; [ mvnetbiz ];
  };
}
