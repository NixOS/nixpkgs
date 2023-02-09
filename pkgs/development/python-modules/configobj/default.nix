{ lib
, buildPythonPackage
, fetchFromGitHub
, mock
, pytestCheckHook
, pythonOlder
, six
}:

buildPythonPackage rec {
  pname = "configobj";
  version = "5.0.6";
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "DiffSK";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-HMLYzVMnxvMpb3ORsbKy18oU/NkuRT0isK6NaUk6J3U=";
  };

  propagatedBuildInputs = [
    six
  ];

  nativeCheckInputs = [
    mock
    pytestCheckHook
  ];

  pythonImportsCheck = [
    "configobj"
  ];

  meta = with lib; {
    description = "Config file reading, writing and validation";
    homepage = "https://pypi.python.org/pypi/configobj";
    license = licenses.bsd3;
    maintainers = with maintainers; [ ];
  };
}
