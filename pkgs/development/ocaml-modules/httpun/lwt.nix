{
  buildDunePackage,
  httpun,
  lwt,
  gluten,
  gluten-lwt,
}:

buildDunePackage {
  pname = "httpun-lwt";

  inherit (httpun) version src;

  propagatedBuildInputs = [
    gluten
    gluten-lwt
    httpun
    lwt
  ];

  meta = httpun.meta // {
    description = "Lwt support for httpun";
  };
}
