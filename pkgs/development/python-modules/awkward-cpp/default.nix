{ lib
, buildPythonPackage
, pythonOlder
, fetchPypi
, cmake
, ninja
, pybind11
, scikit-build-core
, numpy
}:

buildPythonPackage rec {
  pname = "awkward-cpp";
  version = "30";
  pyproject = true;

  disabled = pythonOlder "3.8";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-W+lMpzUdjkIcuUeKm3EBb6dnNiH6Ei1HfQsHu2iqfUw=";
  };

  nativeBuildInputs = [
    cmake
    ninja
    pybind11
    scikit-build-core
  ] ++ scikit-build-core.optional-dependencies.pyproject;

  propagatedBuildInputs = [
    numpy
  ];

  dontUseCmakeConfigure = true;

  pythonImportsCheck = [
    "awkward_cpp"
  ];

  meta = with lib; {
    description = "CPU kernels and compiled extensions for Awkward Array";
    homepage = "https://github.com/scikit-hep/awkward";
    changelog = "https://github.com/scikit-hep/awkward/releases/tag/v${version}";
    license = licenses.bsd3;
    maintainers = with maintainers; [ veprbl ];
  };
}
