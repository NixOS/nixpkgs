{
  buildDunePackage,
  tar,
  eio,
  git,
}:

buildDunePackage {
  pname = "tar-eio";
  inherit (tar) version src doCheck;

  minimalOCamlVersion = "5.1";

  propagatedBuildInputs = [
    tar
    eio
  ];

  nativeCheckInputs = [
    git
  ];

  meta = tar.meta // {
    description = "Decode and encode tar format files using Eio";
  };
}
