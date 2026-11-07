{
  alcotest,
  buildDunePackage,
  dune-configurator,
  fetchFromGitHub,
  lib,
  ocaml,
  openssl,
  pkg-config,
}:

buildDunePackage (finalAttrs: {
  pname = "ssl";
  version = "0.8.1";

  minimalOCamlVersion = "4.12";

  src = fetchFromGitHub {
    owner = "savonet";
    repo = "ocaml-ssl";
    tag = "v${finalAttrs.version}";
    hash = "sha256-SqIklmWpriTV/r1tcI3y/7jGI48Cjk6PtczoQORnE38=";
  };

  nativeBuildInputs = [ pkg-config ];
  buildInputs = [ dune-configurator ];
  propagatedBuildInputs = [ openssl ];

  __darwinAllowLocalNetworking = true;
  doCheck = lib.versionAtLeast ocaml.version "4.14";
  checkInputs = [ alcotest ];

  meta = {
    homepage = "https://www.liquidsoap.info/ocaml-ssl/ssl/index.html";
    description = "OCaml bindings for libssl";
    license = with lib.licenses; [
      lgpl21Plus
      ocamlLgplLinkingException
    ];
    maintainers = with lib.maintainers; [
      dandellion
    ];
  };
})
