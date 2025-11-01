{
  lib,
  buildPythonPackage,
  fetchPypi,

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
  version = "2.31.3";
  pyproject = true;

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-/7Oust4mxADQr/fit0V/ZM1gmklMRe5Xnv/ugbG8XXg=";
  };

  nativeBuildInputs = [
    cmake
    scikit-build-core
    pybind11
    pathspec
    ninja
    pyproject-metadata
  ];

  dependencies = [ numpy ];

  dontUseCmakeConfigure = true;

  nativeCheckInputs = [ pytestCheckHook ];

  meta = with lib; {
    homepage = "https://github.com/scikit-hep/iminuit";
    changelog = "https://github.com/scikit-hep/iminuit/releases/tag/v{version}";
    description = "Python interface for the Minuit2 C++ library";
    license = with licenses; [
      mit
      lgpl2Only
    ];
    maintainers = with maintainers; [ veprbl ];
  };
}
