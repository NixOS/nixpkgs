{
  lib,
  buildDunePackage,
  fetchurl,
}:

buildDunePackage {
  pname = "unisim_archisec";
  version = "0.0.13";

  src = fetchurl {
    url = "https://github.com/binsec/unisim_archisec/releases/download/0.0.13/unisim_archisec-0.0.13.tbz";
    sha256 = "sha256-pDLbsF6n4HSGQyWWEb7/RWK+nCWfS+p6Dy/G5jlnlk0=";
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
