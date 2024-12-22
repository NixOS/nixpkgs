{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  pyheck,
  pytestCheckHook,
  pythonOlder,
}:

buildPythonPackage rec {
  pname = "dotwiz";
  version = "0.4.0";
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "rnag";
    repo = "dotwiz";
    rev = "refs/tags/v${version}";
    hash = "sha256-ABmkwpJ40JceNJieW5bhg0gqWNrR6Wxj84nLCjKU11A=";
  };

  propagatedBuildInputs = [ pyheck ];

  nativeCheckInputs = [ pytestCheckHook ];

  pythonImportsCheck = [ "dotwiz" ];

  pytestFlagsArray = [
    "--ignore=benchmarks"
    "--ignore-glob=*integration*"
  ];

  meta = with lib; {
    description = "Dict subclass that supports dot access notation";
    homepage = "https://github.com/rnag/dotwiz";
    changelog = "https://github.com/rnag/dotwiz/blob/v${version}/HISTORY.rst";
    license = licenses.mit;
    maintainers = with maintainers; [ fab ];
  };
}
