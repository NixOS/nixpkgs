{ buildDunePackage
, tar
, cstruct-lwt
, lwt
, git
}:

buildDunePackage rec {
  pname = "tar-unix";
  inherit (tar) version src doCheck;

  propagatedBuildInputs = [
    tar
    cstruct-lwt
    lwt
  ];

  nativeCheckInputs = [
    git
  ];

  meta = tar.meta // {
    description = "Decode and encode tar format files from Unix";
  };
}
