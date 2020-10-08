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
  version = "1.0.2";
  disabled = pythonOlder "3.6";

  src = fetchPypi {
    inherit pname version;
    sha256 = "0zpn3miyapskw6s71v614pmga5zfain9j085axm9v50b8r71xh1i";
  };

  checkInputs = [
    pytest
  ];

  propagatedBuildInputs = [ click ecdsa hidapi pyaes ];

  meta = with stdenv.lib; {
    description = "Communicate with your Coldcard using Python";
    homepage = "https://github.com/Coldcard/ckcc-protocol";
    license = licenses.gpl3;
    maintainers = [ maintainers.hkjn ];
  };
}
