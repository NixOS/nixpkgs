{ lib
, buildPythonPackage
, editdistance-s
, fetchFromGitHub
, pytestCheckHook
, pythonOlder
, ukkonen
}:

buildPythonPackage rec {
  pname = "identify";
  version = "2.5.15";
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "pre-commit";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-5M51eWdER9/K15H2yUQjvXMjzYNwx9BLIKSW/ToDU5g=";
  };

  nativeCheckInputs = [
    editdistance-s
    pytestCheckHook
    ukkonen
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
