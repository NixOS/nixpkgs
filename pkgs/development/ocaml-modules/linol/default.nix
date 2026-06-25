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

  # linol 0.11 vendors a jsonrpc library whose Json.t type included `Tuple and
  # `Variant, constructors removed from Yojson.Safe.t in yojson 3.0.0.  They
  # are never constructed anywhere in the compiled code, so removing them from
  # the type definition is safe.
  patches = [ ./linol-yojson3.patch ];

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
