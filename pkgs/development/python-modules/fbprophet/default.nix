{
  stdenv,
  buildPythonPackage,
  fetchPypi,
  cython,
  pystan,
  numpy,
  pandas,
  matplotlib,
  lunar-calendar,
  cmdstanpy,
  convertdate,
  holidays,
  setuptools-git,
  python-dateutil,
  setuptools,
  tqdm,
  python
}:

let

  cmdstanpy' = cmdstanpy.overridePythonAttrs (old: rec {
    pname = "cmdstanpy";
    version = "0.4.0";
    src = fetchPypi {
      inherit pname version;
      sha256 = "07wmv36adp8jxf6zdas8n407dx51q7la486s7s40anvq6q0x412n";
    };
  });

in buildPythonPackage rec {
  pname = "fbprophet";
  version = "0.6";

  src = fetchPypi {
    inherit pname version;
    sha256 = "16w9dag0v0pz5zp590z4dy56d5mybivhcsbhl1lvlk8fa0balzny";
  };

  propagatedBuildInputs = [ numpy pandas lunar-calendar convertdate holidays pystan cython matplotlib setuptools setuptools-git tqdm cmdstanpy' ];

  checkPhase = ''
    cd fbprophet/tests/ && ${python.interpreter} -m unittest discover
  '';

  meta = with stdenv.lib; {
    homepage = "https://github.com/facebook/prophet";
    description = "Prophet is a procedure for forecasting time series data based on an additive model where non-linear trends are fit with yearly, weekly, and daily seasonality, plus holiday effects.";
    license = licenses.mit;
    maintainers = with maintainers; [ bletham seanjtaylor ];
  };
}
