{ buildDunePackage, resto, resto-directory, cohttp-lwt }:

buildDunePackage {
  pname = "resto-cohttp";
  inherit (resto) src version meta useDune2 doCheck;

  propagatedBuildInputs = [
    resto
    resto-directory
    cohttp-lwt
  ];
}
