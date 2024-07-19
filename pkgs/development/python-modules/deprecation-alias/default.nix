{ lib
, buildPythonPackage
, pythonOlder
, fetchFromGitHub
, setuptools
, deprecation
, packaging
, pytestCheckHook
}:

buildPythonPackage rec {
  pname = "deprecation-alias";
  version = "0.3.2";
  pyproject = true;

  disabled = pythonOlder "3.6";

  src = fetchFromGitHub {
    owner = "domdfcoding";
    repo = "deprecation-alias";
    rev = "v${version}";
    hash = "sha256-9kuTRjtlSwwnF8YT58Lo+hL/Y2g/IvvxrSImueVQOsk=";
  };

  build-system = [
    setuptools
  ];

  dependencies = [
    deprecation
    packaging
  ];

  pythonImportsCheck = [ "deprecation_alias" ];

  nativeCheckInputs = [
    pytestCheckHook
  ];

  # requires coincidence which hasn't been packaged yet
  doCheck = false;

  meta = {
    description = "A wrapper around 'deprecation' providing support for deprecated aliases";
    homepage = "https://github.com/domdfcoding/deprecation-alias";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ dotlambda ];
  };
}
