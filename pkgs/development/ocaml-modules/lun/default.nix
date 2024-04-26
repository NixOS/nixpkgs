{ lib, buildDunePackage, fetchurl }:

buildDunePackage rec {
  pname = "lun";
  version = "0.0.1";

  minimalOCamlVersion = "4.12.0";

  src = fetchurl {
    url = "https://github.com/robur-coop/lun/releases/download/v${version}/lun-${version}.tbz";
    hash = "sha256-zKi63/g7Rw/c+xhAEW+Oim8suGzeL0TtKM8my/aSp5M=";
  };

  meta = {
    description = "Optics in OCaml";
    homepage = "https://git.robur.coop/robur/lun";
    license = lib.licenses.isc;
    maintainers = with lib.maintainers; [ ];
  };
}
