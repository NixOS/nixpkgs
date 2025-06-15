{
  lib,
  fetchPypi,
  buildPythonPackage,
  pythonOlder,
  setuptools,
  cmake,
  ninja,
  tomli,
  pybind11,
}:

buildPythonPackage rec {
  pname = "pennylane-lightning";
  version = "0.41.1";
  pyproject = true;

  disabled = pythonOlder "3.10";

  # Use fetchPypi to avoid the updater script to migrate it to `reactivex` which
  # is being developed in the same repository
  src = fetchPypi {
    inherit version;
    pname = "pennylane_lightning";
    sha256 = "7d52936352df17c94e2a7e81a4784472754624256262f7ac88ac504596132c91";
  };

  nativeBuildInputs = [
    pybind11
    cmake
    ninja
    tomli
  ];

  build-system = [
    cmake
    pybind11
    ninja
    setuptools
  ];

  doCheck = false; # PyPI tarball does not provides tests

  pythonImportsCheck = [ "pennylane_lightning" ];

  meta = {
    homepage = "https://github.com/PennyLaneAI/pennylane-lightning";
    description = "PennyLane plugins";
    maintainers = with lib.maintainers; [ anderscs ];
    license = lib.licenses.asl20;
  };
}
