{
  lib,
  fetchFromGitHub,
  fetchpatch2,
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

  # backport yojson 3 support merged after v0.11
  patches = [
    (fetchpatch2 {
      url = "https://github.com/c-cube/linol/commit/cf50e29c358ece3a417cb47bf7d17b06b6219d65.patch?full_index=1";
      hash = "sha256-oguHTX20Jr7IatCN1mQZ1JfuX1bN1Fz7trJb8yyNzZM=";
    })
  ];

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
