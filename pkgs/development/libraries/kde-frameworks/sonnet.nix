{ mkDerivation, fetchpatch, extra-cmake-modules, aspell, qtbase, qttools }:

mkDerivation {
  name = "sonnet";
  patches = [
    # Pull upstream path to fix determinism.
    (fetchpatch {
      url =
        "https://invent.kde.org/frameworks/sonnet/-/commit/a01fc66b8affb01221d1fdf84146a78c172d4c6b.patch";
      sha256 = "1jzd65rmgvfpcxrsnsmdz8ac1ldqs9rjfryy8fryy0ibzbhc1050";
    })
  ];
  nativeBuildInputs = [ extra-cmake-modules ];
  buildInputs = [ aspell qttools ];
  propagatedBuildInputs = [ qtbase ];
}
