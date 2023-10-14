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
  version = "2.5.30";
  format = "setuptools";

  disabled = pythonOlder "3.8";

  src = fetchFromGitHub {
    owner = "pre-commit";
    repo = pname;
    rev = "refs/tags/v${version}";
    hash = "sha256-e3+yjd3jrcv4hU+0vCTl+bAzlYcfTdhLHr93briFxdI=";
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
