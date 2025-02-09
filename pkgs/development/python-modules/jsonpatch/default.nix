{ lib
, buildPythonPackage
, fetchFromGitHub
, jsonpointer
, pytestCheckHook
, pythonOlder
}:

buildPythonPackage rec {
  pname = "jsonpatch";
  version = "1.33";
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "stefankoegl";
    repo = "python-json-patch";
    rev = "refs/tags/v${version}";
    hash = "sha256-JHBB64LExzHQVoFF2xcsqGlNWX/YeEBa1M/TmfeQLWI=";
  };

  propagatedBuildInputs = [
    jsonpointer
  ];

  nativeCheckInputs = [
    pytestCheckHook
  ];

  pythonImportsCheck = [
    "jsonpatch"
  ];

  pytestFlagsArray = [
    "tests.py"
  ];

  meta = with lib; {
    description = "Library to apply JSON Patches according to RFC 6902";
    homepage = "https://github.com/stefankoegl/python-json-patch";
    license = licenses.bsd3;
    maintainers = with maintainers; [ ];
  };
}
