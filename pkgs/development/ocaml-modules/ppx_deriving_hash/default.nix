{
  lib,
  fetchurl,
  buildDunePackage,
  cppo,
  ppxlib,
  ppx_deriving,
  ounit2,
}:

let
  param =
    if lib.versionAtLeast ppxlib.version "0.36" then
      {
        version = "0.1.4";
        hash = "sha256-5EYz9DwAdFW+KmE+9B+iTpsBvHJ9sMt3Dhamgz6oLUU=";
      }
    else
      {
        version = "0.1.2";
        hash = "sha256-ss3OALD+9Dm5wtwgvQ0SSL7Cu0xWumwKmLBKPDh4Fa8=";
      };
in

buildDunePackage (finalAttrs: {
  pname = "ppx_deriving_hash";
  inherit (param) version;

  src = fetchurl {
    url = "https://github.com/sim642/ppx_deriving_hash/releases/download/${finalAttrs.version}/ppx_deriving_hash-${finalAttrs.version}.tbz";
    inherit (param) hash;
  };

  propagatedBuildInputs = [
    ppxlib
    ppx_deriving
  ];

  # The test suite only exists since 0.1.4.
  doCheck = lib.versionAtLeast finalAttrs.version "0.1.4";
  nativeCheckInputs = [ cppo ];
  checkInputs = [ ounit2 ];

  meta = {
    homepage = "https://github.com/sim642/ppx_deriving_hash";
    description = "OCaml PPX deriver for standard hash functions without extra dependencies";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ niols ];
  };
})
