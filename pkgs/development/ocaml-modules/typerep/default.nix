{ lib, buildOcaml, fetchFromGitHub, type_conv }:

buildOcaml rec {
  name = "typerep";
  version = "112.24.00";

  minimumSupportedOcamlVersion = "4.00";

  src = fetchFromGitHub {
    owner = "janestreet";
    repo = "typerep";
    rev = version;
    sha256 = "sha256-XCdUZp9Buwmo6qPYAoPD2P/gUgyWHTR7boyecBPKlho=";
  };

  propagatedBuildInputs = [ type_conv ];

  meta = with lib; {
    homepage = "https://github.com/janestreet/typerep";
    description = "Runtime types for OCaml (beta version)";
    license = licenses.asl20;
    maintainers = [ maintainers.ericbmerritt ];
  };

}
