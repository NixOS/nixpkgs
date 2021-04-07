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
  version = "1.1.0";
  disabled = pythonOlder "3.6";

  src = fetchPypi {
    inherit pname version;
    sha256 = "b660225ac06fc06ad17b33ece428126eef785388450e14313f72d25d4082c5ab";
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
