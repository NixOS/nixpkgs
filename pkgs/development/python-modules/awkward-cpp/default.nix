{ lib
, buildPythonPackage
, fetchPypi
, pythonOlder
, cmake
, ninja
, numpy
, pybind11
, scikit-build-core
, typing-extensions
}:

buildPythonPackage rec {
  pname = "awkward-cpp";
  version = "22";
  format = "pyproject";

  disabled = pythonOlder "3.8";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-IWeWNvshz+NxX4ijIyaleRmThNstpKYplcMQUC1/6F8=";
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
    license = licenses.bsd3;
    maintainers = with maintainers; [ veprbl ];
  };
}
