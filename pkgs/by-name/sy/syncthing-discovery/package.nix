{
  syncthing,
}:
(syncthing.override {
  target = "stdiscosrv";
}).overrideAttrs
  {
    pname = "syncthing-discovery";
    postInstall = "";
  }
