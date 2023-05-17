{ lib
, buildPythonPackage
, fetchPypi
, fastprogress
, fastcore
, asttokens
, astunparse
, watchdog
, execnb
, ghapi
, pyyaml
, quarto
, pythonOlder
}:

buildPythonPackage rec {
  pname = "nbdev";
  version = "2.3.12";
  format = "setuptools";
  disabled = pythonOlder "3.6";

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-AQWNqCq9IEWMKkkG5bw0pkvWtvIMKkBbAotfTRRTMCQ=";
  };

  propagatedBuildInputs = [
    fastprogress
    fastcore
    asttokens
    astunparse
    watchdog
    execnb
    ghapi
    pyyaml
    quarto
  ];

  # no real tests
  doCheck = false;
  pythonImportsCheck = [ "nbdev" ];

  meta = with lib; {
    homepage = "https://github.com/fastai/nbdev";
    description = "Create delightful software with Jupyter Notebooks";
    license = licenses.asl20;
    maintainers = with maintainers; [ rxiao ];
  };
}
