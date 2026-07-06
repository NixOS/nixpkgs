{
  buildDunePackage,
  tar,
  fpath,
  logs,
  lwt,
  git,
}:

buildDunePackage {
  pname = "tar-unix";
  inherit (tar) version src doCheck;

  propagatedBuildInputs = [
    tar
    fpath
    logs
    lwt
  ];

  nativeCheckInputs = [
    git
  ];

  meta = tar.meta // {
    description = "Decode and encode tar format files from Unix";
  };
}
