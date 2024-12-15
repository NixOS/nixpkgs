{
  buildPythonPackage,
  fetchPypi,
  lib,
  setuptools,
  setuptools-scm,
}:

buildPythonPackage rec {
  pname = "pybcj";
  version = "1.0.2";

  pyproject = true;

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-x/W+9/R3I8U0ION3vGTSVThDvui8rF8K0HarFSR4ABg=";
  };

  build-system = [
    setuptools
    setuptools-scm
  ];

  meta = {
    homepage = "https://codeberg.org/miurahr/pybcj";
    description = "BCJ(Branch-Call-Jump) filter for python";
    license = lib.licenses.gpl2Plus;
    maintainers = with lib.maintainers; [ PopeRigby ];
  };
}
