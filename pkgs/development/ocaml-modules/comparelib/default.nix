{ lib, buildOcaml, fetchFromGitHub, type_conv, camlp4 }:

buildOcaml rec {
  pname = "comparelib";
  version = "113.00.00";

  minimumSupportedOcamlVersion = "4.00";

  src = fetchFromGitHub {
    owner = "janestreet";
    repo = "comparelib";
    rev = version;
    sha256 = "sha256-gtJvXAUxiIt/L9bCzS+8wHcCQ+QpBubwcjDcyN0K2MA=";
  };

  buildInputs = [ camlp4 ];
  propagatedBuildInputs = [ type_conv ];

  meta = with lib; {
    homepage = "https://github.com/janestreet/comparelib";
    description = "Syntax extension for deriving \"compare\" functions automatically";
    license = licenses.asl20;
    maintainers = [ maintainers.ericbmerritt ];
  };
}
