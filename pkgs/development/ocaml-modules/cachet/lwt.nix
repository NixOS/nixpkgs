{
  buildDunePackage,
  cachet,
  lwt,
  alcotest,
}:

buildDunePackage {
  pname = "cachet-lwt";
  inherit (cachet) src version;
  propagatedBuildInputs = [
    cachet
    lwt
  ];
  doCheck = true;
  checkInputs = [ alcotest ];

  meta = cachet.meta // {
    description = "A simple cache system for mmap and lwt";
  };
}
