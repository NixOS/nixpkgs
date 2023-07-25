{ lib
, argcomplete
, buildPythonPackage
, fetchFromGitHub
, pytestCheckHook
, pythonOlder
, typeguard
}:

buildPythonPackage rec {
  pname = "enhancements";
  version = "0.4.0";
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "ssh-mitm";
    repo = "python-enhancements";
    rev = version;
    hash = "sha256-Nff44WAQwSbkRpUHb9ANsQWWH2B819gtwQdXAjWJJls=";
  };

  propagatedBuildInputs = [
    argcomplete
    typeguard
  ];

  nativeCheckInputs = [
    pytestCheckHook
  ];

  pythonImportsCheck = [
    "enhancements"
  ];

  meta = with lib; {
    description = "Library which extends various Python classes";
    homepage = "https://enhancements.readthedocs.io";
    license = licenses.lgpl3Only;
    maintainers = with maintainers; [ fab ];
  };
}
