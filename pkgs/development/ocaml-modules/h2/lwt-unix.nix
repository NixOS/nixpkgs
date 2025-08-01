{
  buildDunePackage,
  h2,
  h2-lwt,
  gluten-lwt-unix,
  faraday-lwt-unix,
}:

buildDunePackage {
  pname = "h2-lwt-unix";

  inherit (h2) src version;

  propagatedBuildInputs = [
    gluten-lwt-unix
    faraday-lwt-unix
    h2-lwt
  ];

  meta = h2.meta // {
    description = "Lwt Unix support for h2";
  };
}
