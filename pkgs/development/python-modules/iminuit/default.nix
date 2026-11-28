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
  version = "2.33.0";
  pyproject = true;

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-J189qh1PjDNXm5YnbXxftoCnz7b7i+qaQkWhUA1dMos=";
  };

  build-system = [
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

  meta = {
    homepage = "https://github.com/scikit-hep/iminuit";
    changelog = "https://github.com/scikit-hep/iminuit/releases/tag/v${version}";
    description = "Python interface for the Minuit2 C++ library";
    license = with lib.licenses; [
      mit
      lgpl2Only
    ];
    maintainers = with lib.maintainers; [ veprbl ];
  };
}
