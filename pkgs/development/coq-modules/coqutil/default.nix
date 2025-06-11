{
  coq,
  findutils,
  lib,
  mkCoqDerivation,
  version ? null,
}:

mkCoqDerivation {
  pname = "coqutil";
  owner = "mit-plv";

  inherit version;
  defaultVersion =
    with lib.versions;
    lib.switch coq.version [
      {
        case = range "8.18" "8.20";
        out = "0.0.6";
      }
      {
        case = range "8.17" "8.20";
        out = "0.0.5";
      }
    ] null;

  releaseRev = v: "v${v}";
  release."0.0.6".sha256 = "sha256-c/ddrj0ahuaj9Zu7YBqK7Q0ur+LK7Fgaa//nxQpQcm4=";
  release."0.0.5".sha256 = "sha256-vkZIAAr82GNuCGlCVRgSCj/nqIdD8FITBiX1a8fybqw=";

  nativeBuildInputs = [ findutils ];

  meta = {
    description = "Coq library for tactics, basic definitions, sets, maps";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ stepbrobd ];
  };
}
