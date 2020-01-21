{ lib, buildPythonPackage, fetchFromGitHub }:

buildPythonPackage rec {
  version = "1.3.3";
  pname = "elementpath";

  src = fetchFromGitHub {
    owner = "sissaschool";
    repo = "elementpath";
    rev = "v${version}";
    sha256 = "05wplh836ffwhncf5rpdnz4g1b3mqw7jiy83352nw4x3aak4ifbr";
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
