{ lib, buildOcaml, fetchFromGitHub, camlp4 }:

buildOcaml rec {
  pname = "pipebang";
  version = "113.00.00";

  minimumSupportedOcamlVersion = "4.00";

  src = fetchFromGitHub {
    owner = "janestreet";
    repo = "pipebang";
    rev = version;
    sha256 = "sha256-9A3X/ciL5HtuKQ5awS+hDDBLL5ytOr12wHsmJLNRn+Q=";
  };

  strictDeps = true;

  propagatedBuildInputs = [ camlp4 ];

  meta = with lib; {
    homepage = "https://github.com/janestreet/pipebang";
    description = "Syntax extension to transform x |! f into f x";
    license = licenses.asl20;
    maintainers = [ maintainers.ericbmerritt ];
  };
}
