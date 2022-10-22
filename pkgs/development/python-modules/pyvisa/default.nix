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
  version = "1.12.0";

  src = fetchFromGitHub {
    owner = "pyvisa";
    repo = "pyvisa";
    rev = "refs/tags/${version}";
    hash = "sha256-2khTfj0RRna9YDPOs5kQHHhkeMwv3kTtGyDBYnu+Yhw=";
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
