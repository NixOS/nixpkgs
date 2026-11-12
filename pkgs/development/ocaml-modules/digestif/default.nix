{
  lib,
  ocaml,
  fetchurl,
  buildDunePackage,
  eqaf,
  alcotest,
  crowbar,
}:

buildDunePackage (finalAttrs: {
  pname = "digestif";
  version = "1.4.2";

  src = fetchurl {
    url = "https://github.com/mirage/digestif/releases/download/v${finalAttrs.version}/digestif-${finalAttrs.version}.tbz";
    hash = "sha256-Df+Aeg5vN1Kh0Hx5aCDEpnMN47pHiclxC+/ZYFE40y4=";
  };

  propagatedBuildInputs = [ eqaf ];

  checkInputs = [
    alcotest
    crowbar
  ];
  doCheck = true;

  meta = {
    description = "Simple hash algorithms in OCaml";
    homepage = "https://github.com/mirage/digestif";
    license = lib.licenses.mit;
    maintainers = [ lib.maintainers.vbgl ];
  };
})
