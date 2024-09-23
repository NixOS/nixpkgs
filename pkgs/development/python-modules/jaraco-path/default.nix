{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  setuptools-scm,
  pytestCheckHook,
  stdenv,
}:

buildPythonPackage rec {
  pname = "jaraco-path";
  version = "3.7.1";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "jaraco";
    repo = "jaraco.path";
    rev = "refs/tags/v${version}";
    hash = "sha256-i6FPM4aPfpwLdde1COXZNoKel3sRK8PXnkzy50XvVdw=";
  };

  build-system = [ setuptools-scm ];

  pythonImportsCheck = [ "jaraco.path" ];

  nativeCheckInputs = [ pytestCheckHook ];

  meta = {
    changelog = "https://github.com/jaraco/jaraco.path/blob/${src.rev}/NEWS.rst";
    description = "Miscellaneous path functions";
    homepage = "https://github.com/jaraco/jaraco.path";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ dotlambda ];
    broken = stdenv.isDarwin; # pyobjc is missing
  };
}
