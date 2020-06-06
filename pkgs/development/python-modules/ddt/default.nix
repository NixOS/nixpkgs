{ stdenv
, buildPythonPackage
, fetchPypi
, nose, six, pyyaml, mock
}:

buildPythonPackage rec {
  pname = "ddt";
  version = "1.4.1";

  src = fetchPypi {
    inherit pname version;
    sha256 = "0595e70d074e5777771a45709e99e9d215552fb1076443a25fad6b23d8bf38da";
  };

  checkInputs = [ nose six pyyaml mock ];

  checkPhase = ''
    nosetests -s
  '';

  meta = with stdenv.lib; {
    description = "Data-Driven/Decorated Tests, a library to multiply test cases";
    homepage = "https://github.com/txels/ddt";
    license = licenses.mit;
  };

}
