{ stdenv, buildPythonPackage, fetchPypi, pandas, ujson, numpy }:

buildPythonPackage rec {
  pname = "cmdstanpy";
  version = "0.9.5";

  src = fetchPypi {
    inherit pname version;
    sha256 = "13x1yr48dzwzvwcp10kxd00gc4kvv37jhdsmv243ql8dq6j40v4i";
  };

  propagatedBuildInputs = [ pandas ujson numpy ];

  meta = with stdenv.lib; {
    homepage = "https://github.com/stan-dev/cmdstanpy";
    description = "CmdStanPy is a lightweight interface to Stan for Python users which provides the necessary objects and functions to do Bayesian inference given a probability model written as a Stan program and data.";
    license = licenses.mit;
    maintainers = with maintainers; [ ];
  };
}
