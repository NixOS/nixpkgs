{ stdenv, buildPythonPackage, fetchPypi, six
, pytest, unittest2, mock, keyring
}:

buildPythonPackage rec {
  pname = "keyrings.alt";
  version = "2.3";

  src = fetchPypi {
    inherit pname version;
    sha256 = "5cb9b6cdb5ce5e8216533e342d3e1b418ddd210466834061966d7dc1a4736f2d";
  };
  propagatedBuildInputs = [ six ];

  # Fails with "ImportError: cannot import name mock"
  doCheck = false;
  checkInputs = [ pytest unittest2 mock keyring ];

  meta = with stdenv.lib; {
    license = licenses.mit;
    description = "Alternate keyring implementations";
    homepage = https://github.com/jaraco/keyrings.alt;
    maintainers = with maintainers; [ nyarly ];
  };
}
