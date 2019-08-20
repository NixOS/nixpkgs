{ buildPythonPackage
, lib
, fetchFromGitHub
}:

buildPythonPackage rec {
  version = "1.2.0";
  pname = "elementpath";

  src = fetchFromGitHub {
    owner = "sissaschool";
    repo = "elementpath";
    rev = "v${version}";
    sha256 = "1w5yqck8fgrws1i1z1zmc8sr1214m40iwh8q2ar0fja9s2shkh0p";
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
