{ lib
, buildPythonPackage
, fetchFromGitHub
, pytestCheckHook
, pythonOlder
, mypy
, typing-extensions
}:

buildPythonPackage rec {
  pname = "immutables";
  version = "0.19";
  format = "setuptools";

  disabled = pythonOlder "3.6";

  src = fetchFromGitHub {
    owner = "MagicStack";
    repo = pname;
    rev = "refs/tags/v${version}";
    hash = "sha256-yW+pmAryBp6bvjolN91ACDkk5zxvKfu4nRLQSy71kqs=";
  };

  propagatedBuildInputs = lib.optionals (pythonOlder "3.8") [
    typing-extensions
  ];

  nativeCheckInputs = [
    mypy
    pytestCheckHook
  ];

  disabledTests = [
    # Version mismatch
    "testMypyImmu"
  ];

  pythonImportsCheck = [
    "immutables"
  ];

  meta = with lib; {
    description = "An immutable mapping type";
    homepage = "https://github.com/MagicStack/immutables";
    license = with licenses; [ asl20 ];
    maintainers = with maintainers; [ catern ];
  };
}
