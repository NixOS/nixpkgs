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
    rev = "v${version}";
    sha256 = "jB2V/Wpxmp92wba41mWZAeO63wy3NrkupllGxJMNkFM=";
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
    license = licenses.asl20;
    maintainers = with maintainers; [ fab ];
  };
}
