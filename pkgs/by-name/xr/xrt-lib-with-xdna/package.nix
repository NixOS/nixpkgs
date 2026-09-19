{
  symlinkJoin,
  xrt,
  xdna-driver,
}:

symlinkJoin {
  pname = "xrt-lib-with-xdna";
  inherit (xrt) version meta;

  paths = [
    xrt.lib
    xdna-driver
  ];
}
