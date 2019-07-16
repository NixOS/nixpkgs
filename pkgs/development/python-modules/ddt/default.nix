{ stdenv
, buildPythonPackage
, fetchPypi
, nose, six, pyyaml, mock
}:

buildPythonPackage rec {
  pname = "ddt";
  version = "1.2.1";

  src = fetchPypi {
    inherit pname version;
    sha256 = "d13e6af8f36238e89d00f4ebccf2bda4f6d1878be560a6600689e42077e164e3";
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
