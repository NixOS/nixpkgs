{
  lib,
  buildDunePackage,
  fetchurl,
  jose,
  uri,
  junit_alcotest,
}:

buildDunePackage (finalAttrs: {
  pname = "oidc";
  version = "0.2.0";

  src = fetchurl {
    url = "https://github.com/ulrikstrid/ocaml-oidc/releases/download/v${finalAttrs.version}/oidc-v${finalAttrs.version}.tbz";
    hash = "sha256-NE/OW5BesVWhYfTmh3jP+A0TGML7m/Nw+tnafjMCIFo=";
  };

  propagatedBuildInputs = [
    jose
    uri
  ];

  doCheck = true;
  checkInputs = [
    junit_alcotest
  ];

  meta = {
    description = "OpenID Connect implementation in OCaml";
    homepage = "https://github.com/ulrikstrid/ocaml-oidc";
    license = lib.licenses.bsd3;
    maintainers = with lib.maintainers; [
      ulrikstrid
      toastal
      marijanp
    ];
  };
})
