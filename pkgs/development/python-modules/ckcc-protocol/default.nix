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
  version = "1.0.1";
  disabled = pythonOlder "3.6";

  src = fetchPypi {
    inherit pname version;
    sha256 = "13ihbhjgxyn1xvrbppjvnqm199q5fdwrljs0wm16iwyl56kf3wh3";
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
