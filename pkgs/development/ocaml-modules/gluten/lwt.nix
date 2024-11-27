{ buildDunePackage
, gluten
, lwt
}:

buildDunePackage rec {
  pname = "gluten-lwt";
  inherit (gluten) doCheck meta src version;

  propagatedBuildInputs = [
    gluten
    lwt
  ];
}
