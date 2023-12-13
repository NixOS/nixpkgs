{ lib, fetchFromGitHub, buildDunePackage, yojson, logs, lsp, ppx_yojson_conv_lib }:

buildDunePackage
rec {
  pname = "linol";
  version = "2023-08-04";

  minimalOCamlVersion = "4.14";
  duneVersion = "3";

  src = fetchFromGitHub {
    owner = "c-cube";
    repo = "linol";
    # Brings support for newer LSP
    rev = "09311ae258c55c53c62cb5eda3641682e61fe191";
    sha256 = "sha256-51k+Eo3buzby9cWtbl+/0wbAxa2QSS+Oq0aEao0VBCM=";
  };

  lsp_v = lsp.override {
    version = "1.14.2";
  };
  propagatedBuildInputs = [ yojson logs lsp_v ppx_yojson_conv_lib ];

  meta = with lib; {
    description = "LSP server library";
    license = licenses.mit;
    maintainers = [ maintainers.ulrikstrid ];
    homepage = "https://github.com/c-cube/linol";
  };
}
