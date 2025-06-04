{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  setuptools,
  colorama,
  pytestCheckHook,
  unstableGitUpdater,
}:

buildPythonPackage {
  pname = "migen";
  version = "0.9.2-unstable-2025-02-07";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "m-labs";
    repo = "migen";
    rev = "2828df54594673653a641ab551caf6c6b1bfeee5";
    hash = "sha256-GproDJowtcgbccsT+I0mObzFhE483shcS8MSszKXwlc=";
  };

  nativeBuildInputs = [ setuptools ];

  propagatedBuildInputs = [ colorama ];

  nativeCheckInputs = [ pytestCheckHook ];

  pythonImportsCheck = [ "migen" ];

  passthru.updateScript = unstableGitUpdater { };

  meta = {
    description = " A Python toolbox for building complex digital hardware";
    homepage = "https://m-labs.hk/migen";
    license = lib.licenses.bsd2;
    maintainers = with lib.maintainers; [ l-as ];
  };
}
