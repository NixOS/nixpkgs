{ buildDunePackage, resto, resto-directory, ezresto, lwt }:

buildDunePackage {
  pname = "ezresto-directory";
  inherit (resto) src version meta useDune2 doCheck;

  propagatedBuildInputs = [
    ezresto
    resto-directory
    resto
    lwt
  ];
}
