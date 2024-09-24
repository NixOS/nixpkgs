{
  lib,
  buildPythonPackage,
  fetchPypi,
  pythonOlder,

  # build-system
  cmake,
  scikit-build-core,
  pybind11,
  pathspec,
  ninja,
  pyproject-metadata,

  # dependencies
  numpy,

  # tests
  pytestCheckHook,
}:

buildPythonPackage rec {
  pname = "iminuit";
  version = "2.30.0";
  format = "pyproject";

  disabled = pythonOlder "3.6";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-jeC4K7azOBFls46VdhoCcBiaAIPNuS4VTfFlfsZRmkA=";
  };

  nativeBuildInputs = [
    cmake
    scikit-build-core
    pybind11
    pathspec
    ninja
    pyproject-metadata
  ];

  propagatedBuildInputs = [ numpy ];

  dontUseCmakeConfigure = true;

  nativeCheckInputs = [ pytestCheckHook ];

  meta = with lib; {
    homepage = "https://github.com/scikit-hep/iminuit";
    description = "Python interface for the Minuit2 C++ library";
    license = with licenses; [
      mit
      lgpl2Only
    ];
    maintainers = with maintainers; [ veprbl ];
  };
}
