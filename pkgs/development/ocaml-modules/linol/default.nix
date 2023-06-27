{ lib, fetchFromGitHub, buildDunePackage, yojson, logs, lsp, ppx_yojson_conv_lib }:

buildDunePackage
rec {
  pname = "linol";
  version = "2023-04-25";

  minimalOCamlVersion = "4.14";
  duneVersion = "3";

  src = fetchFromGitHub {
    owner = "c-cube";
    repo = "linol";
    # Brings support for newer LSP
    rev = "439534e0c5b7a3fbf93ba05fae7d171426153763";
    sha256 = "sha256-EW35T7KUc/L1Zy4+oaJOC6mlVpbvhTfnU3NNFGoZAJg=";
  };

  propagatedBuildInputs = [ yojson logs lsp ppx_yojson_conv_lib ];

  meta = with lib; {
    description = "LSP server library";
    license = licenses.mit;
    maintainers = [ maintainers.ulrikstrid ];
    homepage = "https://github.com/c-cube/linol";
  };
}
