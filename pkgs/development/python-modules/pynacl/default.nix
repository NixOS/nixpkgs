{ stdenv, buildPythonPackage, fetchFromGitHub, pytest, libsodium, cffi, six, hypothesis}:

buildPythonPackage rec {
  pname = "pynacl";
  version = "1.2.1";

  src = fetchFromGitHub {
    owner = "pyca";
    repo = pname;
    rev = version;
    sha256 = "0z9i1z4hjzmp23igyhvg131gikbrr947506lwfb3fayf0agwfv8f";
  };

  # set timeout to unlimited, remove deadline from tests, see https://github.com/pyca/pynacl/issues/370
  patches = [ ./pynacl-no-timeout-and-deadline.patch ];

  checkInputs = [ pytest hypothesis ];
  propagatedBuildInputs = [ libsodium cffi six ];

  SODIUM_INSTALL = "system";

  checkPhase = ''
    py.test
  '';
  
  meta = with stdenv.lib; {
    maintainers = with maintainers; [ va1entin ];
    description = "Python binding to the Networking and Cryptography (NaCl) library";
    homepage = https://github.com/pyca/pynacl/;
    license = licenses.asl20;
  };
}
