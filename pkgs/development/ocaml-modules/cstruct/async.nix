{
  buildDunePackage,
  cstruct,
  async_unix,
  async,
  core,
}:

buildDunePackage rec {
  pname = "cstruct-async";
  inherit (cstruct) src version meta;

  duneVersion = "3";

  propagatedBuildInputs = [
    async_unix
    async
    cstruct
    core
  ];
}
