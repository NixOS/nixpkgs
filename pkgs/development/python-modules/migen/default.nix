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
  version = "0.9.2-unstable-2025-01-16";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "m-labs";
    repo = "migen";
    rev = "28e913e7114dae485747ccd8f9fd436ada2195f0";
    hash = "sha256-5Rv7R8OO/CsjdDreo+vCUO7dIrTD+70meV5rIvHOGDk=";
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
