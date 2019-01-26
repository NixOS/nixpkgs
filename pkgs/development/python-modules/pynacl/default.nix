{ stdenv, buildPythonPackage, fetchFromGitHub, pytest, libsodium, cffi, six, hypothesis}:

buildPythonPackage rec {
  pname = "pynacl";
  version = "1.3.0";

  src = fetchFromGitHub {
    owner = "pyca";
    repo = pname;
    rev = version;
    sha256 = "0ac00d5bfdmz1x428h2scq5b34llp61yhxradl94qjwz7ikqv052";
  };

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
