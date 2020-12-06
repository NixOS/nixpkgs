{ stdenv
, buildPythonPackage
, fetchFromGitHub
}:

buildPythonPackage rec {
  pname = "hjson";
  version = "3.0.2";

  # N.B. pypi src tarball does not have tests
  src = fetchFromGitHub {
    owner = "hjson";
    repo = "hjson-py";
    rev = "v${version}";
    sha256 = "1jc7j790rcqnhbrfj4lhnz3f6768dc55aij840wmx16jylfqpc2n";
  };

  meta = with stdenv.lib; {
    description = "A user interface for JSON";
    homepage = "https://github.com/hjson/hjson-py";
    license = licenses.mit;
    maintainers = with maintainers; [ bhipple ];
  };
}
