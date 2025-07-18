{
  lib,
  buildDunePackage,
  fetchurl,
}:

buildDunePackage {
  pname = "unisim_archisec";
  version = "0.0.11";

  src = fetchurl {
    url = "https://github.com/binsec/unisim_archisec/releases/download/0.0.11/unisim_archisec-0.0.11.tbz";
    sha256 = "sha256-stzs1BQ7M+q2R82CUdzvP0FVBUvupychbm8z89o4ORY=";
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
