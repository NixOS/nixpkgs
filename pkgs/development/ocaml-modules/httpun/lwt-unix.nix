{
  buildDunePackage,
  httpun-lwt,
  gluten-lwt-unix,
}:

buildDunePackage {
  pname = "httpun-lwt-unix";

  inherit (httpun-lwt) version src;

  propagatedBuildInputs = [
    httpun-lwt
    gluten-lwt-unix
  ];

  meta = httpun-lwt.meta // {
    description = "Lwt + Unix support for httpun";
  };
}
