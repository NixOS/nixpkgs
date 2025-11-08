{
  lib,
  buildDunePackage,
  fetchurl,
  stdlib-shims,
}:

buildDunePackage rec {
  pname = "streaming";
  version = "0.8.0";

  minimalOCamlVersion = "4.08";

  src = fetchurl {
    url = "https://github.com/odis-labs/streaming/releases/download/${version}/streaming-${version}.tbz";
    hash = "sha256-W+3GYZpsLj1SnQhuSmjXdi/85fMajWpz4b7x5W0bnJs=";
  };

  propagatedBuildInputs = [ stdlib-shims ];

  meta = {
    homepage = "https://odis-labs.github.io/streaming";
    license = lib.licenses.isc;
    description = "Fast, safe and composable streaming abstractions";
    maintainers = [ lib.maintainers.vbgl ];
  };
}
