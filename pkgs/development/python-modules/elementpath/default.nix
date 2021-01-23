{ lib, buildPythonPackage, fetchFromGitHub, isPy27 }:

buildPythonPackage rec {
  version = "2.1.1";
  pname = "elementpath";
  disabled = isPy27; # uses incompatible class syntax

  src = fetchFromGitHub {
    owner = "sissaschool";
    repo = "elementpath";
    rev = "v${version}";
    sha256 = "1h910v8f0648nqnk40bxgdim3623m07yg4xdfwcips2h55d19rk2";
  };

  # avoid circular dependency with xmlschema which directly depends on this
  doCheck = false;

  pythonImportsCheck = [ "elementpath" ];

  meta = with lib; {
    description = "XPath 1.0/2.0 parsers and selectors for ElementTree and lxml";
    homepage = "https://github.com/sissaschool/elementpath";
    license = licenses.mit;
    maintainers = with maintainers; [ jonringer ];
  };
}
