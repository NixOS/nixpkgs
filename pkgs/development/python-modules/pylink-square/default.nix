{ lib
, buildPythonPackage
, fetchPypi
, fetchFromGitHub
, mock
, psutil
, six
, future
, pytestCheckHook
}:

buildPythonPackage rec {
  pname = "pylink-square";
  version = "1.2.0";

  format = "setuptools";

  src = fetchFromGitHub {
    owner = "square";
    repo = "pylink";
    rev = "refs/tags/v${version}";
    hash = "sha256-rcM7gvUUfXN5pL9uIihzmOCXA7NKjiMt2GaQaGJxD9M=";
  };

  propagatedBuildInputs = [ psutil six future ];

  nativeCheckInputs = [
    mock
    pytestCheckHook
  ];

  pythonImportsCheck = [ "pylink" ];

  meta = with lib; {
    description = "Python interface for the SEGGER J-Link";
    homepage = "https://github.com/square/pylink";
    changelog = "https://github.com/square/pylink/blob/${src.rev}/CHANGELOG.md";
    maintainers = with maintainers; [ dump_stack ];
    license = licenses.asl20;
  };
}
