{ stdenv, isPy27, buildPythonPackage, fetchPypi, scikitlearn }:

buildPythonPackage rec {
  pname = "mlrose";
  version = "1.3.0";
  disabled = isPy27;

  src = fetchPypi {
    inherit pname version;
    sha256 = "cec83253bf6da67a7fb32b2c9ae13e9dbc6cfbcaae2aa3107993e69e9788f15e";
  };

  propagatedBuildInputs = [ scikitlearn ];

  postPatch = ''
    sed -i 's,sklearn,scikit-learn,g' setup.py
  '';

  meta = with stdenv.lib; {
    description = "Machine Learning, Randomized Optimization and SEarch";
    homepage    = "https://github.com/gkhayes/mlrose";
    license     = licenses.bsd3;
    maintainers = with maintainers; [ abbradar ];
  };
}
