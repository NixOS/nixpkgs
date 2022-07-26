{ lib, buildDunePackage, fetchurl, lwt, duration, mirage-runtime, io-page }:

buildDunePackage rec {
  pname = "mirage-unix";
  version = "4.0.1";

  src = fetchurl {
    url = "https://github.com/mirage/${pname}/releases/download/v${version}/${pname}-v${version}.tbz";
    sha256 = "sha256-9ymVBb3dkhb+MN97/sXe/oQ36CVx0kruj3sd19LiFZ4=";
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
