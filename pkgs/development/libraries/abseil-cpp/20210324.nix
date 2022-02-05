import ./generic.nix {
  version = "20210324.2";
  sha256 = "sha256-fcxPhuI2eL/fnd6nT11p8DpUNwGNaXZmd03yOiZcOT0=";
  patches = fetchpatch: [
    # Use CMAKE_INSTALL_FULL_{LIBDIR,INCLUDEDIR}
    # https://github.com/abseil/abseil-cpp/pull/963
    (fetchpatch {
      url = "https://github.com/abseil/abseil-cpp/commit/5bfa70c75e621c5d5ec095c8c4c0c050dcb2957e.patch";
      sha256 = "0nhjxqfxpi2pkfinnqvd5m4npf9l1kg39mjx9l3087ajhadaywl5";
    })
  ];
}
