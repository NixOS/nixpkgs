{
  lib,
  fetchFromGitHub,
  fetchpatch,
  buildDunePackage,
  yojson,
  logs,
  lsp,
  ppx_yojson_conv_lib,
  trace,
}:

buildDunePackage rec {
  pname = "linol";
  version = "0.5";

  minimalOCamlVersion = "4.14";

  src = fetchFromGitHub {
    owner = "c-cube";
    repo = "linol";
    rev = "v${version}";
    hash = "sha256-ULPOB/hb+2VXDB/eK66WDDh/wj0bOwUt0tZsiIXqndo=";
  };

  patches = fetchpatch {
    url = "https://github.com/c-cube/linol/commit/d8ebcf9a60f1e7251d14cdcd0b2ebd5b7f8eec6d.patch";
    hash = "sha256-JHR0P0X3ep5HvDWW43dMb452/WsFKS4e+5Qhk4MzaxQ=";
  };

  propagatedBuildInputs = [
    yojson
    logs
    lsp
    ppx_yojson_conv_lib
    trace
  ];

  meta = with lib; {
    description = "LSP server library";
    license = licenses.mit;
    maintainers = [ maintainers.ulrikstrid ];
    homepage = "https://github.com/c-cube/linol";
  };
}
