{
  buildXenPackage,
  python3Packages,
}:

buildXenPackage.override { inherit python3Packages; } {
  pname = "xen";
  version = "4.19.2";
  rev = "f3362182e028119e5ca2ab37e5628b9fa6d21254";
  hash = "sha256-c6LXYJ61umJb/r5/utwBWLAfy+tIvpK7QLjI3zKfr6Y=";
}
