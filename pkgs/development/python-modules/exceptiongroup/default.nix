{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  flit-scm,
  pytestCheckHook,
  pythonAtLeast,
  pythonOlder,
}:

buildPythonPackage rec {
  pname = "exceptiongroup";
  version = "1.3.0";
  pyproject = true;

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "agronholm";
    repo = "exceptiongroup";
    tag = version;
    hash = "sha256-b3Z1NsYKp0CecUq8kaC/j3xR/ZZHDIw4MhUeadizz88=";
  };

  nativeBuildInputs = [ flit-scm ];

  nativeCheckInputs = [ pytestCheckHook ];

  doCheck = pythonAtLeast "3.11"; # infinite recursion with pytest

  pythonImportsCheck = [ "exceptiongroup" ];

  meta = with lib; {
    description = "Backport of PEP 654 (exception groups)";
    homepage = "https://github.com/agronholm/exceptiongroup";
    changelog = "https://github.com/agronholm/exceptiongroup/blob/${version}/CHANGES.rst";
    license = with licenses; [ mit ];
    maintainers = with maintainers; [ fab ];
  };
}
