{
  lib,
  buildPythonPackage,
  fetchPypi,
  joblib,
  numba,
  numpy,
  pysam,
  shortuuid,
  tqdm,
  typing-extensions,
  setuptools-scm,
}:

buildPythonPackage rec {
  pname = "ngs-tools";
  version = "1.8.5";
  format = "setuptools";

  src = fetchPypi {
    inherit pname version;
    sha256 = "OA4jahAcWxrDwPzbzJCKIQF5tu8qk/vqn06w7C7cHeA=";
  };

  propagatedBuildInputs = [
    joblib
    numba
    numpy
    pysam
    shortuuid
    tqdm
    typing-extensions
  ];

  nativeBuildInputs = [ setuptools-scm ];
  pythonImportsCheck = [ "ngs_tools" ];

  meta = {
    homepage = "https://github.com/Lioscro/ngs-tools";
    description = "Reusable tools for working with next-generation sequencing (NGS) data";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ youhaveme9 ];
  };
}
