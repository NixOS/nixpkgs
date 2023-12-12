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
  version = "27";
  pyproject = true;

  disabled = pythonOlder "3.8";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-PBllGL/M5wl2bWOHgEExekkUti+Ag+Gj4DtP1upvPI0=";
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
