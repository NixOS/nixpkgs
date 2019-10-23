{ lib, buildPythonPackage, fetchFromGitHub }:

buildPythonPackage rec {
  version = "1.3.0";
  pname = "elementpath";

  src = fetchFromGitHub {
    owner = "sissaschool";
    repo = "elementpath";
    rev = "v${version}";
    sha256 = "0ahqqqpcf3fd6xcdhiwwscincyj6h5xyjaacnqxwph1y1b8mnzyw";
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
