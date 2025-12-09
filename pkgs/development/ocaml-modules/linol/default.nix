{
  lib,
  fetchFromGitHub,
  buildDunePackage,
  logs,
  ppx_yojson_conv_lib,
  trace,
  uutf,
  yojson,
}:

buildDunePackage (finalAttrs: {
  pname = "linol";
  version = "0.10";

  minimalOCamlVersion = "4.14";

  src = fetchFromGitHub {
    owner = "c-cube";
    repo = "linol";
    tag = "v${finalAttrs.version}";
    hash = "sha256-G/5nTJd+MxPgNObKW2Hmmwn4HejQ81c3f4oVXjpNSZg=";
  };

  propagatedBuildInputs = [
    logs
    ppx_yojson_conv_lib
    trace
    uutf
    yojson
  ];

  meta = {
    description = "LSP server library";
    homepage = "https://github.com/c-cube/linol";
    changelog = "https://raw.githubusercontent.com/c-cube/linol/refs/tags/v${finalAttrs.version}/CHANGES.md";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [
      stepbrobd
      ulrikstrid
    ];
  };
})
