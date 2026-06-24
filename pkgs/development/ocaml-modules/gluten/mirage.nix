{
  buildDunePackage,
  gluten,
  gluten-lwt,
  faraday-lwt,
  conduit-mirage,
  mirage-flow,
}:

buildDunePackage {
  pname = "gluten-mirage";
  inherit (gluten) src version;

  propagatedBuildInputs = [
    gluten-lwt
    faraday-lwt
    conduit-mirage
    mirage-flow
  ];

  meta = gluten.meta // {
    hasNoMaintainersButDependents = false;
    description = "Mirage support for gluten";
  };
}
