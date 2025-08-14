{
  buildXenPackage,
  python3Packages,
}:

buildXenPackage.override { inherit python3Packages; } {
  pname = "xen";
  version = "4.19.3";
  rev = "077419f04a3125c58dcf9724c954f98d1e927392";
  hash = "sha256-e9aPLgzNVxUn7WnLbBHwFIN02DAObfA24VjiqdiP+jA=";
}
