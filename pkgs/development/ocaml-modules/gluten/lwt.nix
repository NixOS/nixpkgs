{ buildDunePackage
, gluten
, lwt
}:

buildDunePackage rec {
  pname = "gluten-lwt";
  inherit (gluten) doCheck meta src useDune2 version;

  propagatedBuildInputs = [
    gluten
    lwt
  ];
}
