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
  version = "3.7.2";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "jaraco";
    repo = "jaraco.path";
    tag = "v${version}";
    hash = "sha256-uLkNMhB7aeDJ3fF0Ynjd8MD6+CTKKH8vsB5cH9RPcok=";
  };

  build-system = [ setuptools-scm ];

  pythonImportsCheck = [ "jaraco.path" ];

  nativeCheckInputs = [ pytestCheckHook ];

  meta = {
    changelog = "https://github.com/jaraco/jaraco.path/blob/${src.tag}/NEWS.rst";
    description = "Miscellaneous path functions";
    homepage = "https://github.com/jaraco/jaraco.path";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ dotlambda ];
    broken = stdenv.hostPlatform.isDarwin; # pyobjc is missing
  };
}
