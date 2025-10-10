{
  cudaAtLeast,
  gmp,
  expat,
  libxcrypt-legacy,
  ncurses6,
  python310,
  python311,
  python312,
  stdenv,
  lib,
}:
prevAttrs: {
  buildInputs =
    prevAttrs.buildInputs or [ ]
    ++ [
      gmp
      libxcrypt-legacy
      ncurses6
      python310
      python311
      python312
    ]
    # aarch64,sbsa needs expat
    ++ lib.lists.optionals (stdenv.hostPlatform.isAarch64) [ expat ];

  installPhase =
    prevAttrs.installPhase or ""
    # Python 3.8 is not in nixpkgs anymore, delete Python 3.8 cuda-gdb support
    # to avoid autopatchelf failing to find libpython3.8.so.
    + ''
      find $bin -name '*python3.8*' -delete
      find $bin -name '*python3.9*' -delete
    '';
}
