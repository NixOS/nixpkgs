{ buildPythonPackage
, lib
, fetchFromGitHub
}:

buildPythonPackage rec {
  version = "1.1.8";
  pname = "elementpath";

  src = fetchFromGitHub {
    owner = "sissaschool";
    repo = "elementpath";
    rev = "v${version}";
    sha256 = "0krczvf8r6pb3hb8qaxl9h2b4qwg180xk66gyxjf002im7ri75aj";
  };

  # avoid circular dependency with xmlschema which directly depends on this
  doCheck = false;

  meta = with lib; {
    description = "XPath 1.0/2.0 parsers and selectors for ElementTree and lxml";
    homepage = "https://github.com/sissaschool/elementpath";
    license = licenses.mit;
    maintainers = with maintainers; [ jonringer ];
  };
}
