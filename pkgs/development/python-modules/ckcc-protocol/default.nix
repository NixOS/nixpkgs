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
  version = "1.3.0";
  disabled = pythonOlder "3.6";

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-UVLKJHDPxi9ivY3JyIySmce0NUhxIIlIxVTdPoXMaKM=";
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
