{
  lib,
  mkCoqDerivation,
  coq,
  version ? null,
}:

mkCoqDerivation {
  pname = "Vpl";
  owner = "VERIMAG-Polyhedra";
  inherit version;

  defaultVersion = if lib.versions.range "8.8" "8.9" coq.coq-version then "0.5" else null;

  release."0.5".sha256 = "sha256-mSD/xSweeK9WMxWDdX/vzN96iXo74RkufjuNvtzsP9o=";

  sourceRoot = "source/coq";

  meta = {
    description = "Coq interface to VPL abstract domain of convex polyhedra";
    homepage = "https://amarechal.gitlab.io/home/projects/vpl/";
    license = lib.licenses.lgpl3Only;
    maintainers = [ lib.maintainers.vbgl ];
  };
}
