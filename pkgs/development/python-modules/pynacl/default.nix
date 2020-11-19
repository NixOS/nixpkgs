{ stdenv
, buildPythonPackage
, fetchPypi
, pytest
, libsodium
, cffi
, six
, hypothesis_4
}:

buildPythonPackage rec {
  pname = "pynacl";
  version = "1.4.0";

  src = fetchPypi {
    inherit version;
    pname = "PyNaCl";
    sha256 = "01b56hxrbif3hx8l6rwz5kljrgvlbj7shmmd2rjh0hn7974a5sal";
  };

  checkInputs = [ pytest hypothesis_4 ];
  buildInputs = [ libsodium ];
  propagatedBuildInputs = [ cffi six ];

  SODIUM_INSTALL = "system";

  checkPhase = ''
    py.test
  '';

  meta = with stdenv.lib; {
    maintainers = with maintainers; [ va1entin ];
    description = "Python binding to the Networking and Cryptography (NaCl) library";
    homepage = "https://github.com/pyca/pynacl/";
    license = licenses.asl20;
  };
}
