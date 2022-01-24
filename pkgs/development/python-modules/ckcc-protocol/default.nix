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
  version = "1.2.1";
  disabled = pythonOlder "3.6";

  src = fetchPypi {
    inherit pname version;
    sha256 = "65f0313f9915b36068f6dfcab08e04671621e6227650443bc12e81997081ae7f";
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
