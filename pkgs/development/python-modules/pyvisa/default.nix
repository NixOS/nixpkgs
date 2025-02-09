{ lib
, fetchFromGitHub
, buildPythonPackage
, setuptools-scm
, setuptools
, typing-extensions
, pytestCheckHook
, pythonOlder
}:

buildPythonPackage rec {
  pname = "pyvisa";
  version = "1.13.0";
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "pyvisa";
    repo = "pyvisa";
    rev = "refs/tags/${version}";
    hash = "sha256-TBu3Xko0IxFBT2vzrsOxqEG3y4XfPzISEtbkWkIaCvM=";
  };

  nativeBuildInputs = [
    setuptools-scm
  ];

  propagatedBuildInputs = [
    typing-extensions
    setuptools
  ];

  nativeCheckInputs = [
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
