{ stdenv
, buildPythonPackage
, click
, ecdsa
, hidapi
, lib
, fetchPypi
, pytest
, pyaes
, pythonOlder
}:

buildPythonPackage rec {
  pname = "ckcc-protocol";
  version = "0.8.0";
  disabled = pythonOlder "3.6";

  src = fetchPypi {
    inherit pname version;
    sha256 = "1mbs9l8qycy50j5lq6az7l5d8i40nb0vmlyhcyax298qp6c1r1gh";
  };

  checkInputs = [
    pytest
  ];

  propagatedBuildInputs = [ click ecdsa hidapi pyaes ];

  meta = with stdenv.lib; {
    description = "Communicate with your Coldcard using Python";
    homepage = https://github.com/Coldcard/ckcc-protocol;
    license = licenses.gpl3;
    maintainers = [ maintainers.hkjn ];
  };
}
