{ lib, stdenv
, buildPythonPackage
, fetchPypi
, numpy
, scipy
, six
, paramz
, matplotlib
, cython
, nose
}:

buildPythonPackage rec {
  pname = "GPy";
  version = "1.9.9";

  src = fetchPypi {
    inherit pname version;
    sha256 = "04faf0c24eacc4dea60727c50a48a07ddf9b5751a3b73c382105e2a31657c7ed";
  };

  buildInputs = [ cython ];
  propagatedBuildInputs = [ numpy scipy six paramz matplotlib ];
  checkInputs = [ nose ];

  # $ nosetests GPy/testing/*.py
  # => Ran 483 tests in 112.146s (on 8 cores)
  # So instead, run shorter set of tests
  checkPhase = ''
    nosetests GPy/testing/linalg_test.py
  '';

  # Rebuild cython-generated .c files since the included
  # ones were built with an older version of cython that is
  # incompatible with python3.9
  preBuild = ''
    for fn in $(find . -name '*.pyx'); do
      echo $fn | sed 's/\.\.pyx$/\.c/' | xargs ${cython}/bin/cython -3
    done
  '';

  pythonImportsCheck = [
    "GPy"
  ];

  meta = with lib; {
    description = "Gaussian process framework in Python";
    homepage = "https://sheffieldml.github.io/GPy";
    license = licenses.bsd3;
    maintainers = with maintainers; [ bcdarwin ];
    broken = stdenv.isDarwin;  # See inscrutable error message here: https://github.com/NixOS/nixpkgs/pull/107653#issuecomment-751527547
  };
}
