{ buildPythonPackage, stdenv, lxml, click, fetchFromGitHub, pytest, isPy3k }:

buildPythonPackage rec {
  version = "0.3.24";
  pname = "pyaxmlparser";

  # the PyPI tarball doesn't ship tests.
  src = fetchFromGitHub {
    owner = "appknox";
    repo = pname;
    rev = "v${version}";
    sha256 = "0fys26p7xhbnbdzp80zm6n3mragp38p08nyrsnilfgnlpi6rjpg0";
  };

  disabled = !isPy3k;

  postPatch = ''
    substituteInPlace setup.py --replace "click==6.7" "click"
  '';

  propagatedBuildInputs = [ lxml click ];

  checkInputs = [ pytest ];
  checkPhase = ''
    py.test tests/
  '';

  meta = with stdenv.lib; {
    description = "Python3 Parser for Android XML file and get Application Name without using Androguard";
    homepage = https://github.com/appknox/pyaxmlparser;
    # Files from Androguard are licensed ASL 2.0
    license = with licenses; [ mit asl20 ];
    maintainers = with maintainers; [ ma27 ];
  };
}
