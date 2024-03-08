{ lib
, buildPythonPackage
, fetchPypi
, isPyPy
, snappy
, cffi
, unittestCheckHook
}:

buildPythonPackage rec {
  pname = "python-snappy";
  version = "0.7.1";
  format = "setuptools";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-G8KdNiEdRLufBPPXzPuurrvC9ittQPT8Tt0fsWvFLBM=";
  };

  buildInputs = [ snappy ];

  propagatedBuildInputs = lib.optional isPyPy cffi;

  nativeCheckInputs = [ unittestCheckHook ];

  meta = with lib; {
    description = "Python library for the snappy compression library from Google";
    homepage = "https://github.com/andrix/python-snappy";
    license = licenses.bsd3;
    maintainers = with maintainers; [ ];
  };
}
