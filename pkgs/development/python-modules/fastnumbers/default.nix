{ lib
, stdenv
, buildPythonPackage
, fastnumbers
, fetchFromGitHub
, hypothesis
, numpy
, pytestCheckHook
, pythonOlder
, setuptools
, typing-extensions
}:

buildPythonPackage rec {
  pname = "fastnumbers";
  version = "5.0.1";
  format = "pyproject";

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "SethMMorton";
    repo = pname;
    rev = "refs/tags/${version}";
    hash = "sha256-y9QnFh44zHC+CSlYtKPmkhLSFBUquYZv4qP/pQxu9e0=";
  };

  nativeBuildInputs = [
    setuptools
  ];

  propagatedBuildInputs = [
    typing-extensions
  ];

  # Tests fail due to numeric precision differences on ARM
  # See https://github.com/SethMMorton/fastnumbers/issues/28
  doCheck = !stdenv.hostPlatform.isAarch;

  nativeCheckInputs = [
    hypothesis
    numpy
    pytestCheckHook
  ];

  pythonImportsCheck = [
    "fastnumbers"
  ];

  meta = with lib; {
    description = "Python module for number conversion";
    homepage = "https://github.com/SethMMorton/fastnumbers";
    changelog = "https://github.com/SethMMorton/fastnumbers/blob/${version}/CHANGELOG.md";
    license = licenses.mit;
    maintainers = with maintainers; [ fab ];
  };
}
