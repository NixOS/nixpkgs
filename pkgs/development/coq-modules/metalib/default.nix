{
  lib,
  mkCoqDerivation,
  coq,
  version ? null,
}:

(mkCoqDerivation {
  pname = "metalib";
  owner = "plclub";
  inherit version;
  defaultVersion =
    with lib.versions;
    lib.switch coq.coq-version [
      {
        case = range "8.14" "8.18";
        out = "8.15";
      }
      {
        case = range "8.10" "8.13";
        out = "8.10";
      }
    ] null;
  releaseRev = v: "coq${v}";
  release."8.15".hash = "sha256-Jpj4GQYAAxrbUENgBLNNbqvwhNdeoSFlm4so/lEBd3E=";
  release."8.10".hash = "sha256-WtYc+T/fppkDXIP5rW8ENzBfsvUocYVTdZiKVgC7fnE=";

  meta = with lib; {
    license = licenses.mit;
    maintainers = [ maintainers.jwiegley ];
  };
}).overrideAttrs
  (oldAttrs: {
    sourceRoot = "${oldAttrs.src.name}/Metalib";
  })
