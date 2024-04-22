{ lib, buildDunePackage, fetchurl }:

buildDunePackage rec {
  pname = "unisim_archisec";
  version = "0.0.8";

  src = fetchurl {
    url = "https://github.com/binsec/unisim_archisec/releases/download/0.0.8/unisim_archisec-0.0.8.tbz";
    sha256 = "sha256-D8DumHaQnLsMaVHoUL7w8KgGRTh9Rk+22NNSa0a/qII=";
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
