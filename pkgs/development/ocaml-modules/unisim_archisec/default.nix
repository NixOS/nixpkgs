{ lib, buildDunePackage, fetchurl }:

buildDunePackage rec {
  pname = "unisim_archisec";
  version = "0.0.9";

  src = fetchurl {
    url = "https://github.com/binsec/unisim_archisec/releases/download/0.0.9/unisim_archisec-0.0.9.tbz";
    sha256 = "sha256-K7nBQQvnsGUgzGMLGO71P9L1P43yDol3e17glI8y35E=";
  };

  duneVersion = "3";

  meta = {
    homepage = "https://binsec.github.io";
    downloadPage = "https://github.com/binsec/unisim_archisec";
    description = "UNISIM-VP DBA decoder";
    license = lib.licenses.bsd3;
    maintainers = [ lib.maintainers.david-hamelin ];
  };
}
