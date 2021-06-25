{ lib, buildPythonPackage, fetchFromGitHub, isPy27 }:

buildPythonPackage rec {
  version = "2.2.2";
  pname = "elementpath";
  disabled = isPy27; # uses incompatible class syntax

  src = fetchFromGitHub {
    owner = "sissaschool";
    repo = "elementpath";
    rev = "v${version}";
    sha256 = "sha256-n4zIn2WmFHaVaah2J0mz7Q6G4Ptb8Ms0dwQYbh0Ofcs=";
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
