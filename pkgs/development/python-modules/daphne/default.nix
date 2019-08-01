{ stdenv, buildPythonPackage, isPy3k, fetchFromGitHub, fetchpatch
, asgiref, autobahn, twisted, pytestrunner
, hypothesis, pytest, pytest-asyncio
}:
buildPythonPackage rec {
  pname = "daphne";
  version = "2.3.0";

  disabled = !isPy3k;

  src = fetchFromGitHub {
    owner = "django";
    repo = pname;
    rev = version;
    sha256 = "020afrvbnid13gkgjpqznl025zpynisa96kybmf8q7m3wp1iq1nl";
  };

  patches = [
    # Fix compatibility with Hypothesis 4. See: https://github.com/django/daphne/pull/261
    (fetchpatch {
      url = "https://github.com/django/daphne/commit/2df5096c5b63a791c209e12198ad89c998869efd.patch";
      sha256 = "0046krzcn02mihqmsjd80kk5h5flv44nqxpapa17g6dvq3jnb97n";
    })
  ];

  nativeBuildInputs = [ pytestrunner ];

  propagatedBuildInputs = [ asgiref autobahn twisted ];

  checkInputs = [ hypothesis pytest pytest-asyncio ];

  doCheck = !stdenv.isDarwin; # most tests fail on darwin

  checkPhase = ''
    py.test
  '';

  meta = with stdenv.lib; {
    description = "Django ASGI (HTTP/WebSocket) server";
    license = licenses.bsd3;
    homepage = https://github.com/django/daphne;
  };
}
