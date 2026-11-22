{
  buildDunePackage,
  h2,
  lwt,
  gluten-lwt,
}:

buildDunePackage {
  pname = "h2-lwt";

  inherit (h2) src version;

  propagatedBuildInputs = [
    lwt
    gluten-lwt
    h2
  ];

  meta = h2.meta // {
    description = "Lwt support for h2";
  };
}
