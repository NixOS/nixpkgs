{ lib, fetchurl, buildDunePackage, yojson, logs, lsp, ppx_yojson_conv_lib, trace }:

buildDunePackage
rec {
  pname = "linol";
  version = "0.6";

  minimalOCamlVersion = "4.14";

  src = fetchurl {
    url = "https://github.com/c-cube/linol/releases/download/v${version}/linol-${version}.tbz";
    hash = "sha256-MwEisPJdzZN1VRnssotvExNMYOQdffS+Y2B8ZSUDVfo=";
  };

  propagatedBuildInputs = [ yojson logs lsp ppx_yojson_conv_lib trace ];

  meta = with lib; {
    description = "LSP server library";
    license = licenses.mit;
    maintainers = [ maintainers.ulrikstrid ];
    homepage = "https://github.com/c-cube/linol";
  };
}
