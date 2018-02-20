{ stdenv, buildPythonPackage, fetchFromGitHub, async-timeout, pytest, pytest-asyncio }:
buildPythonPackage rec {
  version = "2.1.5";
  pname = "asgiref";

  # PyPI tarball doesn't include tests directory
  src = fetchFromGitHub {
    owner = "django";
    repo = pname;
    rev = version;
    sha256 = "1khhgg9cwjh4lax5c9aacp42a8sj0icdbrbzwp53if7f1irva58l";
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
