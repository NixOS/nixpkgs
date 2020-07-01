{ stdenv, buildPythonPackage, pythonOlder, fetchFromGitHub, async-timeout, pytest, pytest-asyncio }:
buildPythonPackage rec {
  version = "3.2.7";
  pname = "asgiref";

  disabled = pythonOlder "3.5";

  # PyPI tarball doesn't include tests directory
  src = fetchFromGitHub {
    owner = "django";
    repo = pname;
    rev = version;
    sha256 = "1qf29blzhh6sljaj1adc0p8cnyxh9ar6hky9ccdfbgmrk4rw5kwc";
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
