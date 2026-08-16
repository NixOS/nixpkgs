{
  lib,
  buildDunePackage,
  fetchurl,
  cstruct,
}:

buildDunePackage (finalAttrs: {
  pname = "mirage-random";
  version = "3.0.0";

  duneVersion = "3";

  src = fetchurl {
    url = "https://github.com/mirage/mirage-random/releases/download/v${finalAttrs.version}/mirage-random-v${finalAttrs.version}.tbz";
    sha256 = "sha256-Sf4/KB1kMMwXI+yr5H/JuOmynYPNXwlk9dAA+gFAZs8=";
  };

  propagatedBuildInputs = [ cstruct ];

  meta = {
    description = "Random signatures for MirageOS";
    homepage = "https://github.com/mirage/mirage-random";
    license = lib.licenses.isc;
    maintainers = [ lib.maintainers.vbgl ];
  };
})
