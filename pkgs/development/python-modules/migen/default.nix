{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  setuptools,
  colorama,
  pytestCheckHook,
}:

buildPythonPackage {
  pname = "migen";
  version = "unstable-2024-07-21";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "m-labs";
    repo = "migen";
    rev = "9279e8623f8433bc4f23ac51e5e2331bfe544417";
    hash = "sha256-z3LRhNmKZrjr6rFD0yxtccSa/SWvFIYmb+G/D5d2Jd8=";
  };

  nativeBuildInputs = [ setuptools ];

  propagatedBuildInputs = [ colorama ];

  nativeCheckInputs = [ pytestCheckHook ];

  pythonImportsCheck = [ "migen" ];

  meta = {
    description = " A Python toolbox for building complex digital hardware";
    homepage = "https://m-labs.hk/migen";
    license = lib.licenses.bsd2;
    maintainers = with lib.maintainers; [ l-as ];
  };
}
