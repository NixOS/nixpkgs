{ mkDerivation, lib, fetchpatch, cmake, pkg-config }:

mkDerivation {
  pname = "extra-cmake-modules";

  patches = [
    # https://invent.kde.org/frameworks/extra-cmake-modules/-/merge_requests/268
    (fetchpatch {
      url = "https://invent.kde.org/frameworks/extra-cmake-modules/-/commit/5862a6f5b5cd7ed5a7ce2af01e44747c36318220.patch";
      sha256 = "10y36fc3hnpmcsmjgfxn1rp4chj5yrhgghj7m8gbmcai1q5jr0xj";
    })

    # Fix FindWayland.cmake to use the right pkg-config file.
    # https://invent.kde.org/frameworks/extra-cmake-modules/-/merge_requests/336
    (fetchpatch {
      url = "https://invent.kde.org/frameworks/extra-cmake-modules/-/commit/d7647351c7a10f260643a1b22f9c226437e93aba.patch";
      sha256 = "1cuQg11JkIs4lJYR//f+j9tSa7n/53mERFgZYJ+m+eM=";
    })
  ];

  outputs = [ "out" ];  # this package has no runtime components

  propagatedBuildInputs = [ cmake pkg-config ];

  setupHook = ./setup-hook.sh;

  meta = with lib; {
    platforms = platforms.linux ++ platforms.darwin;
    homepage = "https://invent.kde.org/frameworks/extra-cmake-modules";
    license = licenses.bsd2;
  };
}
