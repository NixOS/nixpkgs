{
  buildDunePackage,
  tar,
  eio,
  alcotest,
  eio_main,
}:

buildDunePackage {
  pname = "tar-eio";
  inherit (tar) version src doCheck;

  minimalOCamlVersion = "5.1";

  propagatedBuildInputs = [
    tar
    eio
  ];

  checkInputs = [
    alcotest
    eio_main
  ];

  meta = tar.meta // {
    description = "Decode and encode tar format files using Eio";
  };
}
