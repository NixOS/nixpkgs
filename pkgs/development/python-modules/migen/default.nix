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
  version = "0.9.2-unstable-2025-10-03";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "m-labs";
    repo = "migen";
    rev = "147f003fb7076ac4c7cf76a9a5ce152dc10e0ca6";
    hash = "sha256-gRAvl5cUvrjq4t7htXsDBt4F8MEbHXFZoS0jbhrEs1I=";
  };

  nativeBuildInputs = [ setuptools ];

  propagatedBuildInputs = [ colorama ];

  nativeCheckInputs = [ pytestCheckHook ];

  pythonImportsCheck = [ "migen" ];

  passthru.updateScript = unstableGitUpdater { };

  meta = {
    description = "Python toolbox for building complex digital hardware";
    homepage = "https://m-labs.hk/migen";
    license = lib.licenses.bsd2;
    maintainers = [ ];
  };
}
