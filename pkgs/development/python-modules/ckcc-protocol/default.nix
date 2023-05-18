{ lib
, buildPythonPackage
, click
, ecdsa
, hidapi
, fetchPypi
, pyaes
, pythonOlder
}:

buildPythonPackage rec {
  pname = "ckcc-protocol";
  version = "1.3.2";
  disabled = pythonOlder "3.6";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-4y5pe0CFD3C1+N0kP/2j9Wser2zkn8Uf4203ci45Rq0=";
  };

  propagatedBuildInputs = [ click ecdsa hidapi pyaes ];

  # Project has no tests
  doCheck = false;
  pythonImportsCheck = [ "ckcc" ];

  meta = with lib; {
    description = "Communicate with your Coldcard using Python";
    homepage = "https://github.com/Coldcard/ckcc-protocol";
    license = licenses.mit;
    maintainers = [ maintainers.hkjn ];
  };
}
