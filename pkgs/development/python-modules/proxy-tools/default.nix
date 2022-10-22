{ lib
, buildPythonPackage
, fetchPypi
}:

buildPythonPackage rec {
  pname = "proxy-tools";
  version = "0.1.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-zLN1H1KcBH4tilhEDYayBTA88P6BRveE0cvNlPCigBA=";
  };

  # no tests in pypi
  doCheck = false;
  pythonImportsCheck = [ "proxy-tools" ];

  meta = with lib; {
    homepage = "https://github.com/jtushman/proxy-tools";
    description = "Simple (hopefuly useful) Proxy (as in the GoF design pattern) implementation for Python";
    license = licenses.bsd2;
    maintainers = with maintainers; [ jojosch ];
  };
}
