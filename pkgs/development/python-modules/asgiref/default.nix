{ stdenv, buildPythonPackage, pythonOlder, fetchFromGitHub, async-timeout, pytest, pytest-asyncio }:
buildPythonPackage rec {
  version = "3.2.5";
  pname = "asgiref";

  disabled = pythonOlder "3.5";

  # PyPI tarball doesn't include tests directory
  src = fetchFromGitHub {
    owner = "django";
    repo = pname;
    rev = version;
    sha256 = "040g2cghpskp427xiw9jv7c0lfj1sk5fc01dds8pi7grkk0br357";
  };

  propagatedBuildInputs = [ async-timeout ];

  checkInputs = [ pytest pytest-asyncio ];

  checkPhase = ''
    py.test
  '';

  meta = with stdenv.lib; {
    description = "Reference ASGI adapters and channel layers";
    license = licenses.bsd3;
    homepage = "https://github.com/django/asgiref";
  };
}
