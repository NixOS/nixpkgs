{ stdenv
, fetchurl
, buildPythonPackage
, isPyPy
, pythonOlder
, isPy3k
, nose
, numpy
, pydot_ng
, scipy
, six
}:

buildPythonPackage rec {
  name = "Theano-0.8.2";

  disabled = isPyPy || pythonOlder "2.6" || (isPy3k && pythonOlder "3.3");

  src = fetchurl {
    url = "mirror://pypi/T/Theano/${name}.tar.gz";
    sha256 = "7463c8f7ed1a787bf881f36d38a38607150186697e7ce7e78bfb94b7c6af8930";
  };

  #preCheck = ''
  #  mkdir -p check-phase
  #  export HOME=$(pwd)/check-phase
  #'';
  doCheck = false;
  # takes far too long, also throws "TypeError: sort() missing 1 required positional argument: 'a'"
  # when run from the installer, and testing with Python 3.5 hits github.com/Theano/Theano/issues/4276,
  # the fix for which hasn't been merged yet.

  # keep Nose around since running the tests by hand is possible from Python or bash
  propagatedBuildInputs = [ stdenv nose numpy numpy.blas pydot_ng scipy six ];

  meta = {
    homepage = http://deeplearning.net/software/theano/;
    description = "A Python library for large-scale array computation";
    license = stdenv.lib.licenses.bsd3;
    maintainers = [ stdenv.lib.maintainers.bcdarwin ];
  };

  passthru.cudaSupport = false;
}
