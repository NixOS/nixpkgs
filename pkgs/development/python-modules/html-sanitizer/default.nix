{ lib, buildPythonPackage, fetchFromGitHub, lxml, beautifulsoup4, pytest, pytestrunner }:

buildPythonPackage rec {
  pname = "html-sanitizer";
  version = "1.9.1";

  src = fetchFromGitHub {
    owner = "matthiask";
    repo = pname;
    rev = version;
    sha256 = "0nnv34924r0yn01rwlk749j5ijy7yxyj302s1i57yjrkqr3zlvas";
  };

  propagatedBuildInputs = [ lxml beautifulsoup4 ];

  meta = with lib; {
    description = "An  allowlist-based and very opinionated HTML sanitizer that can be used both for untrusted and trusted sources.";
    homepage = "https://github.com/matthiask/html-sanitizer";
    license = licenses.bsd3;
  };
}
