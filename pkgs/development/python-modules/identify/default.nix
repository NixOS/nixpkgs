{ lib
, buildPythonPackage
, fetchFromGitHub
, pytestCheckHook
, editdistance-s
, pythonOlder
}:

buildPythonPackage rec {
  pname = "identify";
  version = "2.3.6";
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "pre-commit";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-1+ILyqb0Ve+YmP9K+tin4iYIWUoRpi/+fbuyUFZOzBE=";
  };

  checkInputs = [
    editdistance-s
    pytestCheckHook
  ];

  pythonImportsCheck = [
    "identify"
  ];

  meta = with lib; {
    description = "File identification library for Python";
    homepage = "https://github.com/chriskuehl/identify";
    license = licenses.mit;
    maintainers = with maintainers; [ fab ];
  };
}
