{ buildPythonPackage
, fetchPypi
, hyperopt
, lib
, numpy
, prometheus_client
}:

buildPythonPackage rec {
  pname = "gradient-utils";
  version = "0.3.2";

  src = fetchPypi {
    inherit pname version;
    sha256 = "0a99yygv30vibfawk6zd1jd6lva8fjnr99l1ahaf0nqjyw6jl4nw";
  };

  postPatch = ''
    sed -i 's/hyperopt==0.1.2/hyperopt>=0.1.2/' setup.py
    sed -i 's/numpy==1.18.5/numpy>=1.18.5/' setup.py
  '';

  propagatedBuildInputs = [ hyperopt prometheus_client numpy ];

  pythonImportsCheck = [ "gradient_utils" ];

  meta = with lib; {
    description = "Gradient ML SDK";
    homepage    = "https://github.com/Paperspace/gradient-utils";
    license     = licenses.mit;
    platforms   = platforms.unix;
    maintainers = with maintainers; [ freezeboy ];
  };
}
