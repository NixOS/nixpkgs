{
  lib,
  fetchurl,
  buildDunePackage,
  alcotest,
}:

buildDunePackage (finalAttrs: {
  pname = "cachet";
  version = "0.0.2";

  minimalOCamlVersion = "4.13";

  src = fetchurl {
    url = "https://github.com/robur-coop/cachet/releases/download/v${finalAttrs.version}/cachet-${finalAttrs.version}.tbz";
    hash = "sha256:7cf3d609523592516ee5570c106756168d9dca264412a0ef4085d9864c53cbad";
  };

  doCheck = true;
  checkInputs = [
    alcotest
  ];

  meta = {
    description = "A simple cache system for mmap";
    homepage = "https://git.robur.coop/robur/cachet";
    license = lib.licenses.mit;
    maintainers = [ lib.maintainers.vbgl ];
  };
})
