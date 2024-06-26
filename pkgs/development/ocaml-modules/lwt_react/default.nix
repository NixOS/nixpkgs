{
  lib,
  buildDunePackage,
  fetchFromGitHub,
  cppo,
  lwt,
  react,
}:

buildDunePackage {
  pname = "lwt_react";
  version = "1.1.5";

  useDune2 = true;

  src = fetchFromGitHub {
    owner = "ocsigen";
    repo = "lwt";
    rev = "5.5.0";
    sha256 = "sha256:1jbjz2rsz3j56k8vh5qlmm87hhkr250bs2m3dvpy9vsri8rkzj9z";
  };

  nativeBuildInputs = [ cppo ];

  propagatedBuildInputs = [
    lwt
    react
  ];

  meta = {
    description = "Helpers for using React with Lwt";
    inherit (lwt.meta) homepage license maintainers;
  };
}
