{
  lib,
  buildDunePackage,
  fetchurl,
}:

buildDunePackage {
  pname = "unisim_archisec";
  version = "0.0.14";

  src = fetchurl {
    url = "https://github.com/binsec/unisim_archisec/releases/download/0.0.14/unisim_archisec-0.0.14.tbz";
    sha256 = "sha256-Rhi/V52lAGSksDmItcxdB5bt5nF/duR+GSirJCfZqwQ=";
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
