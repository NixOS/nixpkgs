{ lib, buildDunePackage, fetchurl, lwt, duration, mirage-runtime }:

buildDunePackage rec {
  pname = "mirage-unix";
  version = "5.0.1";

  duneVersion = "3";

  src = fetchurl {
    url = "https://github.com/mirage/${pname}/releases/download/v${version}/${pname}-${version}.tbz";
    hash = "sha256-U1oLznUDBcJLcVygfSiyl5qRLDM27cm/WrjT0vSGhPg=";
  };

  propagatedBuildInputs = [ lwt duration mirage-runtime ];
  doCheck = true;

  meta = with lib; {
    homepage = "https://github.com/mirage/mirage-unix";
    description = "Unix core platform libraries for MirageOS";
    license = licenses.isc;
    maintainers = with maintainers; [ sternenseemann ];
  };
}
