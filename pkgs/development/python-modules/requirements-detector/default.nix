{
  lib,
  astroid,
  buildPythonPackage,
  fetchFromGitHub,
  fetchpatch,
  packaging,
  poetry-core,
  semver,
  pytestCheckHook,
  pythonOlder,
}:

buildPythonPackage rec {
  pname = "requirements-detector";
  version = "1.3.2";
  pyproject = true;

  disabled = pythonOlder "3.12";

  src = fetchFromGitHub {
    owner = "landscapeio";
    repo = "requirements-detector";
    tag = version;
    hash = "sha256-IWVIYDE/5/9sFgOFftRE4nmY0IDJ0oOvvaGMODkozQg=";
  };

  patches = [
    # Remove duplicate import, https://github.com/prospector-dev/requirements-detector/pull/53
    (fetchpatch {
      name = "remove-import.patch";
      url = "https://github.com/prospector-dev/requirements-detector/commit/be412669f53a78b3376cac712c84f158fbb1374a.patch";
      hash = "sha256-IskSs3BZ1pTeqjtCUksC8wL+3fOYqAi7nw/QD0zsie4=";
    })
  ];

  build-system = [ poetry-core ];

  dependencies = [
    astroid
    packaging
    semver
  ];

  nativeCheckInputs = [ pytestCheckHook ];

  pythonImportsCheck = [ "requirements_detector" ];

  meta = with lib; {
    description = "Python tool to find and list requirements of a Python project";
    homepage = "https://github.com/landscapeio/requirements-detector";
    changelog = "https://github.com/landscapeio/requirements-detector/releases/tag/${version}";
    license = licenses.mit;
    maintainers = with maintainers; [ kamadorueda ];
    mainProgram = "detect-requirements";
  };
}
