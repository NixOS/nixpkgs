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
  version = "1.0.0";

  format = "setuptools";

  src = fetchFromGitHub {
    owner = "square";
    repo = "pylink";
    rev = "refs/tags/v${version}";
    hash = "sha256-05mg2raHiKg0gHxF/7zFd81C/8OrhStThMwEnpaFGSc=";
  };

  propagatedBuildInputs = [ psutil six future ];

  checkInputs = [
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
