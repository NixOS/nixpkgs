{ lib
, buildDunePackage
, tar
, cstruct
, cstruct-lwt
, re
, lwt
}:

buildDunePackage rec {
  pname = "tar-unix";
  inherit (tar) version src useDune2 doCheck;

  propagatedBuildInputs = [
    tar
    cstruct
    cstruct-lwt
    re
    lwt
  ];

  meta = {
    description = "Decode and encode tar format files from Unix";
    license = lib.licenses.mit;
    maintainers = [ lib.maintainers.ulrikstrid ];
  };
}
