{
  buildDunePackage,
  gluten,
  lwt,
}:

buildDunePackage {
  pname = "gluten-lwt";
  inherit (gluten)
    doCheck
    meta
    src
    version
    ;

  propagatedBuildInputs = [
    gluten
    lwt
  ];
}
