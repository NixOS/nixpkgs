{
  mkDerivation,
  lib,
  fetchpatch,
  bash,
  cmake,
  pkg-config,
}:

mkDerivation {
  pname = "extra-cmake-modules";

  patches = [
    # https://invent.kde.org/frameworks/extra-cmake-modules/-/merge_requests/268
    (fetchpatch {
      url = "https://invent.kde.org/frameworks/extra-cmake-modules/-/commit/5862a6f5b5cd7ed5a7ce2af01e44747c36318220.patch";
      sha256 = "10y36fc3hnpmcsmjgfxn1rp4chj5yrhgghj7m8gbmcai1q5jr0xj";
    })
  ];

  outputs = [ "out" ]; # this package has no runtime components

  nativeBuildInputs = [
    cmake
  ];

  buildInputs = [
    bash
  ];

  # note: these will be propagated into the same list extra-cmake-modules is in
  propagatedBuildInputs = [
    cmake
    pkg-config
  ];

  strictDeps = true;

  setupHook = ./setup-hook.sh;

  meta = with lib; {
    platforms = platforms.linux ++ platforms.darwin;
    homepage = "https://invent.kde.org/frameworks/extra-cmake-modules";
    license = licenses.bsd2;
  };
}
