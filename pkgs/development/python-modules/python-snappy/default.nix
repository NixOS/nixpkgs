{
  lib,
  buildPythonPackage,
  fetchPypi,
  cramjam,
  setuptools,
  snappy,
  unittestCheckHook,
}:

buildPythonPackage rec {
  pname = "python-snappy";
  version = "0.7.3";
  pyproject = true;

  src = fetchPypi {
    pname = "python_snappy";
    inherit version;
    hash = "sha256-QCFsG637LTiseB7LFiodDsQPjul0fmELz+/fp5SGzuM=";
  };

  build-system = [
    cramjam
    setuptools
  ];

  buildInputs = [ snappy ];

  dependencies = [ cramjam ];

  nativeCheckInputs = [ unittestCheckHook ];

  meta = with lib; {
    description = "Python library for the snappy compression library from Google";
    homepage = "https://github.com/intake/python-snappy";
    license = licenses.bsd3;
    maintainers = [ ];
  };
}
