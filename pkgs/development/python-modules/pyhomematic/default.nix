{ stdenv, buildPythonPackage, isPy3k, fetchFromGitHub }:

buildPythonPackage rec {
  pname = "pyhomematic";
  version = "0.1.40";

  disabled = !isPy3k;

  # PyPI tarball does not include tests/ directory
  src = fetchFromGitHub {
    owner = "danielperna84";
    repo = pname;
    rev = version;
    sha256 = "0rflfak505cgc69594yc9chz5mblqvc2d7bbbfcddzhlhs5qcsq2";
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
