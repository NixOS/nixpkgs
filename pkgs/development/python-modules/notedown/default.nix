{
  buildPythonPackage,
  fetchPypi,
  lib,
  nbconvert,
  nbformat,
  notebook,
  pandoc-attributes,
  six,
}:

buildPythonPackage rec {
  pname = "notedown";
  version = "1.5.1";
  format = "setuptools";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-NuAz67vlrKD6sDH/rzYR1bxcUCN99o/4G7lfi+NToe4=";
  };

  propagatedBuildInputs = [
    notebook
    nbconvert
    nbformat
    pandoc-attributes
    six
  ];

  # No tests in pypi source
  doCheck = false;

  meta = {
    homepage = "https://github.com/aaren/notedown";
    description = "Convert IPython Notebooks to markdown (and back)";
    mainProgram = "notedown";
    license = lib.licenses.bsd2;
    maintainers = with lib.maintainers; [ vcanadi ];
  };
}
