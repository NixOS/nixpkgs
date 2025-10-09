{
  lib,
  mkCoqDerivation,
  coq,
  stdlib,
  findutils,
  version ? null,
}:

(mkCoqDerivation {
  pname = "coqutil";
  owner = "mit-plv";

  inherit version;
  defaultVersion =
    with lib.versions;
    lib.switch coq.version [
      {
        case = isGe "9.0";
        out = "0.0.7";
      }
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
  release."0.0.7".sha256 = "sha256-A5QDQscZ9BUxxcGTI2RDYOKTZoCYexJQuGNl9i+Wt/g=";
  release."0.0.6".sha256 = "sha256-c/ddrj0ahuaj9Zu7YBqK7Q0ur+LK7Fgaa//nxQpQcm4=";
  release."0.0.5".sha256 = "sha256-vkZIAAr82GNuCGlCVRgSCj/nqIdD8FITBiX1a8fybqw=";

  nativeBuildInputs = [ findutils ];

  propagatedBuildInputs = [ ];

  meta = {
    description = "Coq library for tactics, basic definitions, sets, maps";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ stepbrobd ];
  };
}).overrideAttrs
  (
    o:
    lib.optionalAttrs (o.version != null && o.version != "dev" && lib.versionAtLeast o.version "0.0.7")
      {
        propagatedBuildInputs = o.propagatedBuildInputs ++ [ stdlib ];
      }
  )
