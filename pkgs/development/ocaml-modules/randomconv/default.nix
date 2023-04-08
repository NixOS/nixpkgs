{ lib, buildDunePackage, fetchurl, cstruct }:

buildDunePackage rec {
  pname = "randomconv";
  version = "0.1.3";

  duneVersion = "3";

  src = fetchurl {
    url = "https://github.com/hannesm/randomconv/releases/download/v${version}/randomconv-v${version}.tbz";
    sha256 = "1iv3r0s5kqxs893b0d55f0r62k777haiahfkkvvfbqwgqsm6la4v";
  };

  propagatedBuildInputs = [ cstruct ];

  meta = {
    homepage = "https://github.com/hannesm/randomconv";
    description = "Convert from random bytes to random native numbers";
    license = lib.licenses.isc;
    maintainers = [ lib.maintainers.vbgl ];
  };

}
