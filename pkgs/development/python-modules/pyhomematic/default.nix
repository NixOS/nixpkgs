{ stdenv, buildPythonPackage, isPy3k, fetchFromGitHub }:

buildPythonPackage rec {
  pname = "pyhomematic";
  version = "0.1.41";

  disabled = !isPy3k;

  # PyPI tarball does not include tests/ directory
  src = fetchFromGitHub {
    owner = "danielperna84";
    repo = pname;
    rev = version;
    sha256 = "01j6y2ypi7a8ffnkqd8j8vnpszza2cxqpiqbnk1dwbg9w9pwwq53";
  };

  # Unreliable timing: https://github.com/danielperna84/pyhomematic/issues/126
  doCheck = false;

  meta = with stdenv.lib; {
    description = "Python 3 Interface to interact with Homematic devices";
    homepage = https://github.com/danielperna84/pyhomematic;
    license = licenses.mit;
    maintainers = with maintainers; [ dotlambda ];
  };
}
