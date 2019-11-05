{ lib, buildPythonPackage, fetchFromGitHub }:

buildPythonPackage rec {
  version = "1.3.1";
  pname = "elementpath";

  src = fetchFromGitHub {
    owner = "sissaschool";
    repo = "elementpath";
    rev = "v${version}";
    sha256 = "0060cd49m0q25k7anzyiz76360hag2f9j5hvqhbmscivf1ssckzq";
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
