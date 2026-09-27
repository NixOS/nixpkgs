{
  lib,
  buildDunePackage,
  fetchFromCodeberg,
  nix-update-script,
  alcotest,
}:

buildDunePackage (finalAttrs: {
  pname = "monocypher";
  version = "0.3.0";

  __structuredAttrs = true;

  src = fetchFromCodeberg {
    owner = "eris";
    repo = "ocaml-monocypher";
    tag = "v${finalAttrs.version}";
    hash = "sha256-rUHiYQlopW0Dzz3nZIU0S+DqiLsjTofaItvPPuhfFs4=";
  };

  doCheck = true;
  checkInputs = [
    alcotest
  ];

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "OCaml bindings to the Monocypher crytographic library";
    homepage = "https://codeberg.org/eris/ocaml-monocypher/";
    license = lib.licenses.OR [
      lib.licenses.bsd2
      lib.licenses.cc0
    ];
    maintainers = [ lib.maintainers.sempiternal-aurora ];
  };
})
