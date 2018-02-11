{ stdenv, buildPythonPackage, fetchFromGitHub, pytest, coverage, libsodium, cffi, six, hypothesis}:

buildPythonPackage rec {
  pname = "pynacl";
  version = "1.2.1";

  src = fetchFromGitHub {
    owner = "pyca";
    repo = pname;
    rev = version;
    sha256 = "0z9i1z4hjzmp23igyhvg131gikbrr947506lwfb3fayf0agwfv8f";
  };

  #remove deadline from tests, see https://github.com/pyca/pynacl/issues/370
  preCheck = ''
    sed -i 's/deadline=1500, //' tests/test_pwhash.py
    sed -i 's/deadline=1500, //' tests/test_aead.py
  '';

  checkInputs = [ pytest coverage hypothesis ];
  propagatedBuildInputs = [ libsodium cffi six ];

  checkPhase = ''
    coverage run --source nacl --branch -m pytest
  '';
  
  meta = with stdenv.lib; {
    maintainers = with maintainers; [ va1entin ];
    description = "Python binding to the Networking and Cryptography (NaCl) library";
    homepage = https://github.com/pyca/pynacl/;
    license = licenses.asl20;
  };
}
