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
  version = "1.0.0";
  disabled = pythonOlder "3.6";

  src = fetchPypi {
    inherit pname version;
    sha256 = "1glws7z7kk9qyl1j4446hb6vv3l4s5xca40zb4fzhsh6chm76h11";
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
