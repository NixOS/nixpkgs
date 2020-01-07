{ lib, buildPythonPackage, fetchFromGitHub }:

buildPythonPackage rec {
  version = "1.4.0";
  pname = "elementpath";

  src = fetchFromGitHub {
    owner = "sissaschool";
    repo = "elementpath";
    rev = "v${version}";
    sha256 = "1fmwy7plcgxam09cx3z11068k0c98wcsgclmxdq8chsd6id3632y";
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
