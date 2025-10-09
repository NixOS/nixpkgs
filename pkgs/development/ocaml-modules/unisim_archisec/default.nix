{
  lib,
  buildDunePackage,
  fetchurl,
}:

buildDunePackage {
  pname = "unisim_archisec";
  version = "0.0.12";

  src = fetchurl {
    url = "https://github.com/binsec/unisim_archisec/releases/download/0.0.12/unisim_archisec-0.0.12.tbz";
    sha256 = "sha256-RJKyyrQy4zrI3S9e7q3W5UbwsGnSlItXq6X0n69UsL8=";
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
