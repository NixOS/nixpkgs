{ stdenv
, buildPythonPackage
, fetchPypi
, nose, six, pyyaml, mock
}:

buildPythonPackage rec {
  pname = "ddt";
  version = "1.2.2";

  src = fetchPypi {
    inherit pname version;
    sha256 = "9f79cf234064cf9b43492b72da35c473de3f03163d37bd13cec5bd8d200dda6b";
  };

  checkInputs = [ nose six pyyaml mock ];

  checkPhase = ''
    nosetests -s
  '';

  meta = with stdenv.lib; {
    description = "Data-Driven/Decorated Tests, a library to multiply test cases";
    homepage = https://github.com/txels/ddt;
    license = licenses.mit;
  };

}
