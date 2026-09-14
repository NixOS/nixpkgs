{
  buildDunePackage,
  alcotest-lwt,
  cachet-lwt,
  carton,
  carton-lwt,
  digestif,
}:

buildDunePackage {
  pname = "carton-git-lwt";

  inherit (carton) version src;

  propagatedBuildInputs = [
    cachet-lwt
    carton
    carton-lwt
    digestif
  ];

  doCheck = true;

  checkInputs = [
    alcotest-lwt
  ];

  inherit (carton) meta;
}
