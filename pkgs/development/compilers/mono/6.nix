{
  callPackage,
  fetchurl,
  fetchpatch,
}:

callPackage ./generic.nix rec {
  version = "6.14.1";
  src = fetchurl {
    url = "https://dl.winehq.org/mono/sources/mono/mono-${version}.tar.xz";
    hash = "sha256-MCTJfAvIy81hHEAdX5lFKHBBCM6zHzGyjepHgwBNCCA=";
  };
  extraPatches = [
    # https://gitlab.winehq.org/mono/mono/-/merge_requests/101
    # fixes a pointer cast on aarch64 that causes crashes
    (fetchpatch {
      url = "https://gitlab.winehq.org/mono/mono/-/commit/2224c6915a98f870cc9a3a9f9e3698e7b20e3d27.patch";
      hash = "sha256-qyc3t1OyDzWBSnNW+W2YpdgFfTBs1Ew13jwdGKs09u0=";
    })
  ];
}
