{ buildDunePackage
, faraday-lwt-unix
, gluten
, gluten-lwt
, lwt_ssl
}:

buildDunePackage rec {
  pname = "gluten-lwt-unix";
  inherit (gluten) doCheck meta src version;

  duneVersion = "3";

  propagatedBuildInputs = [
    faraday-lwt-unix
    gluten-lwt
    lwt_ssl
  ];
}
