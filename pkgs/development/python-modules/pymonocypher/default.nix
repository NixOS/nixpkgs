{
  lib,
  buildPythonPackage,
  fetchPypi,
  setuptools-scm,
  pytestCheckHook,
  cython,
  numpy,
}:
buildPythonPackage rec {
  pname = "pymonocypher";
  version = "4.0.2.2";
  pyproject = true;

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-wCP+SUnnbPqnl+MMNoLZudGSPbGNL9zr2nU/Wpe3yo4=";
  };

  build-system = [
    cython
    setuptools-scm
  ];

  dependencies = [ numpy ];

  doCheck = true;
  nativeCheckInputs = [ pytestCheckHook ];

  meta = {
    description = "Python bindings for Monocypher crypto library";
    homepage = "https://github.com/jetperch/pymonocypher";
    license = with lib.licenses; [
      cc0
      bsd2
    ];
    maintainers = with lib.maintainers; [ xyven1 ];
  };
}
