{ lib
, buildDunePackage
, tar
, cstruct-lwt
, lwt
}:

buildDunePackage rec {
  pname = "tar-unix";
  inherit (tar) version src doCheck;

  propagatedBuildInputs = [
    tar
    cstruct-lwt
    lwt
  ];

  meta = tar.meta // {
    description = "Decode and encode tar format files from Unix";
  };
}
