{ stdenv, buildPythonPackage, fetchFromGitHub, async-timeout, pytest, pytest-asyncio }:
buildPythonPackage rec {
  version = "2.1.6";
  pname = "asgiref";

  # PyPI tarball doesn't include tests directory
  src = fetchFromGitHub {
    owner = "django";
    repo = pname;
    rev = version;
    sha256 = "12p1i2ai03x2hx6b3i7xgicyfi2x11is6pkbdac4jpz7fmbz3zlh";
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
