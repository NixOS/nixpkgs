{
  lib,
  fetchFromGitHub,
  buildDunePackage,
  logs,
  ppx_yojson_conv_lib,
  trace,
  uutf,
}:

buildDunePackage (finalAttrs: {
  pname = "linol";
  version = "0.11";

  minimalOCamlVersion = "4.14";

  src = fetchFromGitHub {
    owner = "c-cube";
    repo = "linol";
    tag = "v${finalAttrs.version}";
    hash = "sha256-9n610J62IPUXYQ/u+WjGTtowYFKQ45wE8M7UkLdEKVM=";
  };

  propagatedBuildInputs = [
    logs
    ppx_yojson_conv_lib
    trace
    uutf
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
