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
  version = "0.14.2";

  format = "setuptools";

  src = fetchFromGitHub {
    owner = "square";
    repo = "pylink";
    rev = "refs/tags/v${version}";
    hash = "sha256-4jmFU8jlrEAYTAQH+uQCWrzqwKX4onb7Xk4iTYzx9dI=";
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
