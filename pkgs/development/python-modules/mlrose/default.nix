{ stdenv, isPy27, buildPythonPackage, fetchPypi, scikitlearn }:

buildPythonPackage rec {
  pname = "mlrose";
  version = "1.2.0";
  disabled = isPy27;

  src = fetchPypi {
    inherit pname version;
    sha256 = "0vsvqrf1wbbj8i198rqd87hf8rlq7fmv8mmibv8f9rhj0w8729p5";
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
