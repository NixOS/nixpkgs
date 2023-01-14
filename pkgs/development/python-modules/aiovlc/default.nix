{ lib
, buildPythonPackage
, click
, fetchFromGitHub
, pytest-asyncio
, pytest-timeout
, pytestCheckHook
, pythonOlder
}:

buildPythonPackage rec {
  pname = "aiovlc";
  version = "0.1.0";
  format = "setuptools";

  disabled = pythonOlder "3.8";

  src = fetchFromGitHub {
    owner = "MartinHjelmare";
    repo = pname;
    rev = "refs/tags/v${version}";
    hash = "jB2V/Wpxmp92wba41mWZAeO63wy3NrkupllGxJMNkFM=";
  };

  propagatedBuildInputs = [
    click
  ];

  checkInputs = [
    pytest-asyncio
    pytest-timeout
    pytestCheckHook
  ];

  pythonImportsCheck = [
    "aiovlc"
  ];

  meta = with lib; {
    description = "Python module to control VLC";
    homepage = "https://github.com/MartinHjelmare/aiovlc";
    changelog = "https://github.com/MartinHjelmare/aiovlc/blob/v${version}/CHANGELOG.md";
    license = licenses.asl20;
    maintainers = with maintainers; [ fab ];
  };
}
