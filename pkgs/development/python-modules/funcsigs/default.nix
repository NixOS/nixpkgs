{
  lib,
  buildPythonPackage,
  fetchPypi,
  isPyPy,
  isPy3k,
}:

buildPythonPackage rec {
  pname = "funcsigs";
  version = "1.0.2";
  format = "setuptools";

  src = fetchPypi {
    inherit pname version;
    sha256 = "0l4g5818ffyfmfs1a924811azhjj8ax9xd1cffr1mzd3ycn0zfx7";
  };

  # https://github.com/testing-cabal/funcsigs/issues/10
  patches = lib.optionals (isPyPy && isPy3k) [ ./fix-pypy3-tests.patch ];

  # requires, unittest2 and package hasn't been maintained since 2013
  doCheck = false;

  pythonImportsCheck = [ "funcsigs" ];

  meta = with lib; {
    description = "Python function signatures from PEP362 for Python 2.6, 2.7 and 3.2+";
    homepage = "https://github.com/aliles/funcsigs";
    maintainers = with maintainers; [ ];
    license = licenses.asl20;
  };
}
