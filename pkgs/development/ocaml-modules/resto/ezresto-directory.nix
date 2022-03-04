{ buildDunePackage, resto, resto-directory, ezresto, lwt }:

buildDunePackage {
  pname = "ezresto-directory";
  inherit (resto) src version meta doCheck;

  propagatedBuildInputs = [
    ezresto
    resto-directory
    resto
    lwt
  ];
}
