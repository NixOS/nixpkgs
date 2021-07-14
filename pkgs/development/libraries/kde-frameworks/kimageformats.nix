{
  mkDerivation, lib, fetchpatch,
  extra-cmake-modules,
  ilmbase, karchive, openexr, qtbase
}:

let inherit (lib) getDev; in

mkDerivation {
  name = "kimageformats";

  patches = [
    (fetchpatch { # included in kimageformats >= 5.82
      name = "CVE-2021-36083.patch";
      url = "https://invent.kde.org/frameworks/kimageformats/-/commit/297ed9a2fe339bfe36916b9fce628c3242e5be0f.diff";
      sha256 = "16axaljgaar0j5796x1mjps93y92393x8zywh3nzw7rm9w2qxzml";
    })
  ];

  nativeBuildInputs = [ extra-cmake-modules ];
  buildInputs = [ karchive openexr qtbase ];
  outputs = [ "out" ]; # plugins only
  CXXFLAGS = "-I${getDev ilmbase}/include/OpenEXR";

  meta = with lib; {
    broken = versionOlder qtbase.version "5.14";
  };
}
