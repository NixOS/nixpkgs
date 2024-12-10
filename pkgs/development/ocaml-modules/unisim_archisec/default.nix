{
  lib,
  buildDunePackage,
  fetchurl,
}:

buildDunePackage rec {
  pname = "unisim_archisec";
  version = "0.0.5";

  src = fetchurl {
    url = "https://github.com/binsec/unisim_archisec/releases/download/0.0.5/unisim_archisec-0.0.5.tbz";
    sha256 = "sha256-94Ky7rtR8oFTtWshTYaY6gyJdqrY3QKMF7qTkZQweXQ=";
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
