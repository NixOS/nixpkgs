{
  buildXenPackage,
  python3Packages,
}:

buildXenPackage.override { inherit python3Packages; } {
  pname = "xen";
  version = "4.20.0-rc1";
  upstreamVersion = "4.20-rc";
  rev = "19730dbb3fd8078743d5196bd7fc32f3765557ad";
  hash = "sha256-ayktDd4KzrendP0AKMQJXf/Y/3waQvf3JeL/PHhoAbs=";
}
