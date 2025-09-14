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
  version = "2.31.1";
  format = "pyproject";

  disabled = pythonOlder "3.6";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-1eAE8f/YPSoHZAn79KeWkeehfJ1zlQu2NGWvMuEE3hg=";
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

  meta = {
    homepage = "https://github.com/scikit-hep/iminuit";
    description = "Python interface for the Minuit2 C++ library";
    license = with lib.licenses; [
      mit
      lgpl2Only
    ];
    maintainers = with lib.maintainers; [ veprbl ];
  };
}
