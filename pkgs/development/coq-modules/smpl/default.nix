{
  lib,
  mkCoqDerivation,
  coq,
  version ? null,
}:

mkCoqDerivation {
  pname = "smpl";
  owner = "uds-psl";

  release."8.10.2".sha256 = "sha256-TUfTZKBgrSOT6piXRViHSGPE9NSj3bGx2XBIw6YCcEs=";
  release."8.12".sha256 = "sha256-UQbDHLVBKYk++o+Y2B6ARYRYGglytsnXhguwMatjOHg=";
  release."8.13".sha256 = "sha256-HxQBaIE2CjyfG4GoIXprfehqjsr/Z74YdodxMmrbzSg=";
  release."8.14".sha256 = "sha256:0wmrc741j67ch4rkygjkrz5i9afi01diyyj69i24cmasvx4wad38";
  release."8.15".sha256 = "sha256:0m9xlkdhilvqb0v4q9c4hzfwffbccd6029ks39xg7qbiq6zklpvp";
  releaseRev = v: "v${v}";

  inherit version;
  defaultVersion =
    with lib.versions;
    lib.switch coq.version [
      {
        case = isEq "8.15";
        out = "8.15";
      }
      {
        case = isEq "8.14";
        out = "8.14";
      }
      {
        case = "8.13.2";
        out = "8.13";
      }
      {
        case = "8.12.2";
        out = "8.12";
      }
      {
        case = "8.10.2";
        out = "8.10.2";
      }
    ] null;

  mlPlugin = true;

  meta = with lib; {
    description = "A Coq plugin providing an extensible tactic similar to first";
    maintainers = with maintainers; [ siraben ];
    license = licenses.mit;
    platforms = platforms.unix;
  };
}
