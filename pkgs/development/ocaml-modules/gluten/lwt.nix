{ buildDunePackage
, gluten
, lwt
}:

buildDunePackage rec {
  pname = "gluten-lwt";
  inherit (gluten) doCheck meta src version;

  duneVersion = "3";

  propagatedBuildInputs = [
    gluten
    lwt
  ];
}
