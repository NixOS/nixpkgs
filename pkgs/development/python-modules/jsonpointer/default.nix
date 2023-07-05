{ lib
, buildPythonPackage
, fetchFromGitHub
, pythonOlder
, unittestCheckHook
}:

buildPythonPackage rec {
  pname = "jsonpointer";
  version = "2.4";
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "stefankoegl";
    repo = "python-json-pointer";
    rev = "refs/tags/v${version}";
    hash = "sha256-Q69s++qqpxFzKznxTFITMA0iP3mm7K7q0hLvXMDkMCw=";
  };

  nativeCheckInputs = [
    unittestCheckHook
  ];

  pythonImportsCheck = [
    "jsonpointer"
  ];

  meta = with lib; {
    description = "Resolve JSON Pointers in Python";
    homepage = "https://github.com/stefankoegl/python-json-pointer";
    license = licenses.bsd2;
    maintainers = with maintainers; [ ];
  };
}
