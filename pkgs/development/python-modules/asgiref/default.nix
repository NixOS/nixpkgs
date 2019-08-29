{ stdenv, buildPythonPackage, pythonOlder, fetchFromGitHub, async-timeout, pytest, pytest-asyncio }:
buildPythonPackage rec {
  version = "3.2.1";
  pname = "asgiref";

  disabled = pythonOlder "3.5";

  # PyPI tarball doesn't include tests directory
  src = fetchFromGitHub {
    owner = "django";
    repo = pname;
    rev = version;
    sha256 = "16wb137dvnjmbmshy4r9vgsfjc4g8d6l527aj9d5vszyk5x5fm7d";
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
