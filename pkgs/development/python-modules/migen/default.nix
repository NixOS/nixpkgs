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
  version = "0.9.2-unstable-2025-06-10";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "m-labs";
    repo = "migen";
    rev = "6e3a9e150fb006dabc4b55043d3af18dbfecd7e8";
    hash = "sha256-NshlPiORBHWljSUP5bB7YBxe7k8dW0t8UXOsIq2EK8I=";
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
    maintainers = with lib.maintainers; [ l-as ];
  };
}
