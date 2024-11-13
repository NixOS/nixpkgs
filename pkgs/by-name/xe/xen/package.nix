{
  buildXenPackage,
  python3Packages,
}:

buildXenPackage.override { inherit python3Packages; } {
  pname = "xen";
  version = "4.19.0-unstable-2024-11-12";
  rev = "251a9496485a86f302980a3f8d3c656831b5a62f";
  hash = "sha256-kHuB6kagH3AU+Wsx4oD7HnNsZpxCu7x3v/m4/1xi6lY=";
}
