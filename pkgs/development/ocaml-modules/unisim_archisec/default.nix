{
  lib,
  buildDunePackage,
  fetchurl,
}:

buildDunePackage rec {
  pname = "unisim_archisec";
  version = "0.0.10";

  src = fetchurl {
    url = "https://github.com/binsec/unisim_archisec/releases/download/0.0.10/unisim_archisec-0.0.10.tbz";
    sha256 = "sha256-lMWiShhl3YWI764EgHqoXXce+NGRe2clOBVrq9OqLfg=";
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
