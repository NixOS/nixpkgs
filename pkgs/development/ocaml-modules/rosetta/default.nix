{
  buildDunePackage,
  coin,
  fetchzip,
  lib,
  yuscii,
  uuuu,
}:

buildDunePackage (finalAttrs: {
  pname = "rosetta";
  version = "0.3.0";

  src = fetchzip {
    url = "https://github.com/mirage/rosetta/releases/download/v${finalAttrs.version}/rosetta-v${finalAttrs.version}.tbz";
    sha256 = "1gzp3fbk8qd207cm25dgj9kj7b44ldqpjs63pl6xqvi9hx60m3ij";
  };

  duneVersion = "3";

  propagatedBuildInputs = [
    coin
    uuuu
    yuscii
  ];

  doCheck = false; # No tests.

  meta = {
    description = "Universal decoder of an encoded flow (UTF-7, ISO-8859 and KOI8) to Unicode";
    license = lib.licenses.mit;
    homepage = "https://github.com/mirage/rosetta";
    maintainers = [ ];
  };
})
