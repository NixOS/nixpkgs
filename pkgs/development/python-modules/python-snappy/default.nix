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
  version = "0.7.1";
  pyproject = true;

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-G8KdNiEdRLufBPPXzPuurrvC9ittQPT8Tt0fsWvFLBM=";
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
