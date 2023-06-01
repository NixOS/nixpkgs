{ lib
, buildPythonPackage
, fetchPypi
, pythonOlder
, cmake
, numpy
, pybind11
, scikit-build-core
, typing-extensions
}:

buildPythonPackage rec {
  pname = "awkward-cpp";
  version = "15";
  format = "pyproject";

  disabled = pythonOlder "3.7";

  src = fetchPypi {
    inherit pname version;
    sha256 = "f6c825db2db981f852903d9574a07015c5d53ef8e4630772f18c7f167045aa0d";
  };

  nativeBuildInputs = [
    cmake
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
