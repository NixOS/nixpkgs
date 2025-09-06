{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  parameterized,
  unittestCheckHook,
}:
buildPythonPackage rec {
  pname = "pypika";
  version = "0.49.0";
  format = "setuptools";

  src = fetchFromGitHub {
    owner = "kayak";
    repo = "pypika";
    rev = "v${version}";
    hash = "sha256-Lawsc19sJ3U7rCOnYvDWhWqK/J+Hd3zKG6TrhDsTtVs=";
  };

  pythonImportsCheck = [ "pypika" ];

  nativeCheckInputs = [
    parameterized
    unittestCheckHook
  ];

  meta = with lib; {
    description = "Python SQL query builder";
    homepage = "https://github.com/kayak/pypika";
    license = licenses.asl20;
    maintainers = with maintainers; [ ];
  };
}
