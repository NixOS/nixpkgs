{ lib, buildDunePackage, fetchurl, ocaml_lwt, duration, mirage-runtime, io-page-unix }:

buildDunePackage rec {
  pname = "mirage-unix";
  version = "4.0.0";

  src = fetchurl {
    url = "https://github.com/mirage/${pname}/releases/download/v${version}/${pname}-v${version}.tbz";
    sha256 = "0kyd83bkpjhn382b4mw3a4325xr8vms78znxqvifpcyfvfnlx7hj";
  };

  propagatedBuildInputs = [ ocaml_lwt duration mirage-runtime io-page-unix ];
  doCheck = true;

  meta = with lib; {
    homepage = "https://github.com/mirage/mirage-unix";
    description = "Unix core platform libraries for MirageOS";
    license = licenses.isc;
    maintainers = with maintainers; [ sternenseemann ];
  };
}
