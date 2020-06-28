{ stdenv
,  buildPythonPackage
,  fetchPypi
,  cython
,  numpy
}:

buildPythonPackage rec {
  pname = "pystan";
  version = "2.19.1.1";

  src = fetchPypi {
    inherit pname version;
    sha256 = "0f5hbv9dhsx3b5yn5kpq5pwi1kxzmg4mdbrndyz2p8hdpj6sv2zs";
  };

  nativeBuildInputs = [ cython ];
  propagatedBuildInputs = [ numpy ];

  doCheck = false;

  meta = with stdenv.lib; {
    homepage = "https://github.com/stan-dev/pystan";
    description = "PyStan provides a Python interface to Stan, a package for Bayesian inference using the No-U-Turn sampler, a variant of Hamiltonian Monte Carlo.";
    license = licenses.mit;
    maintainers = with maintainers; [ ahartikainen ariddell ];
  };
}
