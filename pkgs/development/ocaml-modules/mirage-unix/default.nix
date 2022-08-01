{ lib, buildDunePackage, fetchurl, lwt, duration, mirage-runtime, io-page }:

buildDunePackage rec {
  pname = "mirage-unix";
  version = "5.0.0";

  src = fetchurl {
    url = "https://github.com/mirage/${pname}/releases/download/v${version}/${pname}-${version}.tbz";
    sha256 = "sha256-gQ16af73ebsg131d+DqUy7iKzdlWrxp2aczQJ4T8Hps=";
  };

  propagatedBuildInputs = [ lwt duration mirage-runtime io-page ];
  doCheck = true;

  meta = with lib; {
    homepage = "https://github.com/mirage/mirage-unix";
    description = "Unix core platform libraries for MirageOS";
    license = licenses.isc;
    maintainers = with maintainers; [ sternenseemann ];
  };
}
