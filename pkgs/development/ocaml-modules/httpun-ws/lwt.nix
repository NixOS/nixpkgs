{
  lib,
  buildDunePackage,
  lwt,
  digestif,
  httpun-ws,
  gluten-lwt,
}:

buildDunePackage {
  pname = "httpun-ws-lwt";

  inherit (httpun-ws) src version;

  propagatedBuildInputs = [
    httpun-ws
    lwt
    digestif
    gluten-lwt
  ];

  doCheck = true;

  meta = httpun-ws.meta // {
    description = "Lwt support for httpun-ws";
  };
}
