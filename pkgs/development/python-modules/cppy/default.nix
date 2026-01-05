{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  pythonOlder,
  pytestCheckHook,
  setuptools-scm,
}:

buildPythonPackage rec {
  pname = "cppy";
  version = "1.3.1";
  pyproject = true;

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "nucleic";
    repo = "cppy";
    tag = version;
    hash = "sha256-/u9JQ2ivjSlBPodfAjeDmJ+HUu1rFZ58p3V5L2dy4Jk=";
  };

  build-system = [ setuptools-scm ];

  nativeCheckInputs = [ pytestCheckHook ];

  pythonImportsCheck = [ "cppy" ];

  meta = {
    changelog = "https://github.com/nucleic/cppy/releases/tag/${src.tag}";
    description = "C++ headers for C extension development";
    homepage = "https://github.com/nucleic/cppy";
    license = lib.licenses.bsd3;
  };
}
