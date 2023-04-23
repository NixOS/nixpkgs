{ lib
, stdenv
, buildPythonPackage
, pythonOlder
, fetchFromGitHub
, setuptools
, setuptools-scm
, jaraco_text
, jaraco_collections
, keyring
, pytestCheckHook
}:

buildPythonPackage rec {
  pname = "jaraco-email";
  version = "3.1.0";

  disabled = pythonOlder "3.7";

  format = "pyproject";

  src = fetchFromGitHub {
    owner = "jaraco";
    repo = "jaraco.email";
    rev = "refs/tags/v${version}";
    hash = "sha256-MR/SX5jmZvEMULgvQbh0JBZjIosNCPWl1wvEoJbdw4Y=";
  };

  nativeBuildInputs = [
    setuptools
    setuptools-scm
  ];

  SETUPTOOLS_SCM_PRETEND_VERSION = version;

  propagatedBuildInputs = [
    jaraco_text
    jaraco_collections
    keyring
  ];

  pythonImportsCheck = [ "jaraco.email" ];

  nativeCheckInputs = [
    pytestCheckHook
  ];

  meta = {
    changelog = "https://github.com/jaraco/jaraco.email/blob/${src.rev}/CHANGES.rst";
    description = "E-mail facilities by jaraco";
    homepage = "https://github.com/jaraco/jaraco.email";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ dotlambda ];
  };
}
