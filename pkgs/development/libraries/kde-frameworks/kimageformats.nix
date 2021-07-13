{
  mkDerivation, lib, fetchpatch,
  extra-cmake-modules,
  ilmbase, karchive, openexr, libavif, qtbase
}:

let inherit (lib) getDev; in

mkDerivation {
  name = "kimageformats";

  patches = [
    (fetchpatch { # included in kimageformats >= 5.83
      name = "avif-0.9.2.diff";
      url = "https://invent.kde.org/frameworks/kimageformats/-/commit/bf3f94da766d66a0470ab744dbe1ced4697b572d.diff";
      sha256 = "18d67l5kj9sv88jdpi061k9rl3adzkx9l51ng7saylrkfddwc3ig";
    })
    (fetchpatch { # included in kimageformats >= 5.82
      name = "CVE-2021-36083.patch";
      url = "https://invent.kde.org/frameworks/kimageformats/-/commit/297ed9a2fe339bfe36916b9fce628c3242e5be0f.diff";
      sha256 = "16axaljgaar0j5796x1mjps93y92393x8zywh3nzw7rm9w2qxzml";
    })
  ];

  nativeBuildInputs = [ extra-cmake-modules ];
  buildInputs = [ karchive openexr libavif qtbase ];
  outputs = [ "out" ]; # plugins only
  CXXFLAGS = "-I${getDev ilmbase}/include/OpenEXR";

  meta = with lib; {
    broken = versionOlder qtbase.version "5.14";
  };
}
