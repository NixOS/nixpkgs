{ lib
, buildPythonPackage
, fetchFromGitHub
, hypothesis
, pytest
, pytestCheckHook
, pythonOlder
}:

buildPythonPackage rec {
  pname = "pytest-asyncio";
  version = "0.17.0";
  format = "setuptools";

  disabled = pythonOlder "3.6";

  src = fetchFromGitHub {
    owner = "pytest-dev";
    repo = pname;
    rev = "v${version}";
    sha256 = "1c7xddg76pixwlwdl4zxwpy48q2q619i8kzjx2c67a0i8xbx1q5r";
  };

  buildInputs = [
    pytest
  ];

  checkInputs = [
    hypothesis
    pytestCheckHook
  ];

  pythonImportsCheck = [
    "pytest_asyncio"
  ];

  meta = with lib; {
    description = "library for testing asyncio code with pytest";
    homepage = "https://github.com/pytest-dev/pytest-asyncio";
    license = licenses.asl20;
    maintainers = with maintainers; [ ];
  };
}
