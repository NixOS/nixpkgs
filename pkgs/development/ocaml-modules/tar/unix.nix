{
  buildDunePackage,
  tar,
  lwt,
  git,
}:

buildDunePackage {
  pname = "tar-unix";
  inherit (tar) version src doCheck;

  propagatedBuildInputs = [
    tar
    lwt
  ];

  nativeCheckInputs = [
    git
  ];

  meta = tar.meta // {
    description = "Decode and encode tar format files from Unix";
  };
}
