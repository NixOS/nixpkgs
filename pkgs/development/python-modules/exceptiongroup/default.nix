{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  flit-scm,
  pytestCheckHook,
  pythonOlder,
  pythonAtLeast,
}:

buildPythonPackage rec {
  pname = "exceptiongroup";
  version = "1.2.1";
  format = "pyproject";

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "agronholm";
    repo = "exceptiongroup";
    rev = version;
    hash = "sha256-87HmZsbsoV7QPHux50sYsFY2RaIc3627dH3WAwqXfQU=";
  };

  nativeBuildInputs = [ flit-scm ];

  doCheck = pythonAtLeast "3.11"; # infinite recursion with pytest

  nativeCheckInputs = [ pytestCheckHook ];

  disabledTests =
    if pythonAtLeast "3.12" then
      [
        # https://github.com/agronholm/exceptiongroup/issues/116
        "test_deep_split"
        "test_deep_subgroup"
      ]
    else
      null;

  pythonImportsCheck = [ "exceptiongroup" ];

  meta = with lib; {
    description = "Backport of PEP 654 (exception groups)";
    homepage = "https://github.com/agronholm/exceptiongroup";
    changelog = "https://github.com/agronholm/exceptiongroup/blob/${version}/CHANGES.rst";
    license = with licenses; [ mit ];
    maintainers = with maintainers; [ fab ];
  };
}
