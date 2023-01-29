{ buildDunePackage
, faraday-lwt-unix
, gluten
, gluten-lwt
, lwt_ssl
}:

buildDunePackage rec {
  pname = "gluten-lwt-unix";
  inherit (gluten) doCheck meta src useDune2 version;

  propagatedBuildInputs = [
    faraday-lwt-unix
    gluten-lwt
    lwt_ssl
  ];
}
