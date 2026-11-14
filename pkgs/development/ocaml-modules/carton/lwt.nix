{
  buildDunePackage,
  alcotest-lwt,
  cachet-lwt,
  carton,
  digestif,
  lwt,
}:

buildDunePackage {
  pname = "carton-lwt";

  inherit (carton) version src;

  propagatedBuildInputs = [
    cachet-lwt
    carton
    lwt
  ];

  doCheck = true;

  checkInputs = [
    alcotest-lwt
    digestif
  ];

  inherit (carton) meta;
}
