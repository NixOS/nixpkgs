{
  buildXenPackage,
  python3Packages,
}:

buildXenPackage.override { inherit python3Packages; } {
  pname = "xen";
  version = "4.20.0";
  rev = "3ad5d648cda5add395f49fc3704b2552aae734f7";
  hash = "sha256-v2DRJv+1bym8zAgU74lo1HQ/9rUcyK3qc4Eec4RpcEY=";
}
