{ lib
, buildPythonPackage
, fetchFromGitHub
, pytestCheckHook
, editdistance-s
, pythonOlder
}:

buildPythonPackage rec {
  pname = "identify";
  version = "2.3.7";
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "pre-commit";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-L71Zi0SWFh7K4BRwF57prdrIdxLp8Igs0k/gc6k1+Mo=";
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
