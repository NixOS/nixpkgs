{ lib, buildOcaml, fetchFromGitHub, type_conv, pa_ounit }:

buildOcaml rec {
  pname = "pa_bench";
  version = "113.00.00";

  minimumSupportedOcamlVersion = "4.00";

  src = fetchFromGitHub {
    owner = "janestreet";
    repo = "pa_bench";
    rev = version;
    sha256 = "sha256-WaXB3lgNPHy/z6D7uHxfD5W4HYuTZ+ieRbxxHlPao7c=";
  };

  buildInputs = [ pa_ounit ];
  propagatedBuildInputs = [ type_conv ];

  meta = with lib; {
    homepage = "https://github.com/janestreet/pa_bench";
    description = "Syntax extension for inline benchmarks";
    license = licenses.asl20;
    maintainers = [ maintainers.ericbmerritt ];
  };
}
