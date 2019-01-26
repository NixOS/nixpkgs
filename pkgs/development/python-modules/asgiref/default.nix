{ stdenv, buildPythonPackage, pythonOlder, fetchFromGitHub, async-timeout, pytest, pytest-asyncio }:
buildPythonPackage rec {
  version = "2.3.2";
  pname = "asgiref";

  disabled = pythonOlder "3.5";

  # PyPI tarball doesn't include tests directory
  src = fetchFromGitHub {
    owner = "django";
    repo = pname;
    rev = version;
    sha256 = "1ljymmcscyp3bz33kjbhf99k04fbama87vg4069gbgj6lnxjpzav";
  };

  propagatedBuildInputs = [ async-timeout ];

  checkInputs = [ pytest pytest-asyncio ];

  checkPhase = ''
    py.test
  '';

  meta = with stdenv.lib; {
    description = "Reference ASGI adapters and channel layers";
    license = licenses.bsd3;
    homepage = https://github.com/django/asgiref;
  };
}
