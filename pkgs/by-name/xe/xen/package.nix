{
  buildXenPackage,
  python3Packages,
}:

buildXenPackage.override { inherit python3Packages; } {
  pname = "xen";
  version = "4.19.3-unstable-2025-07-09";
  upstreamVersion = "4.19.3-pre";
  rev = "b026848daf3cca7a4e1d234c8a3b91ebed270e65";
  hash = "sha256-ThlKeS8SgrcXJvwSIQIE+GvSd5WmTskw+S9JowwFVHg=";
}
