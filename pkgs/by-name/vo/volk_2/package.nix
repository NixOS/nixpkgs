{
  stdenv,
  lib,
  fetchFromGitHub,
  cmake,
  python311,
  enableModTool ? true,
  removeReferencesTo,
  fetchpatch,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "volk";
  # Version 2.5.1 seems to cause a build issue for aarch64-darwin[1], and for
  # gnuradio 3.8 on all platforms[2]. Hence we pin this package to 2.5.0 and
  # use it for GR 3.8 for all platforms.
  #
  # [1]: https://github.com/NixOS/nixpkgs/pull/160152#issuecomment-1043380478A
  # [2]: https://github.com/NixOS/nixpkgs/pull/330477#issuecomment-2254477735
  version = "2.5.0";

  src = fetchFromGitHub {
    owner = "gnuradio";
    repo = "volk";
    rev = "v${finalAttrs.version}";
    hash = "sha256-XvX6emv30bSB29EFm6aC+j8NGOxWqHCNv0Hxtdrq/jc=";
    fetchSubmodules = true;
  };

  patches = [
    (fetchpatch {
      url = "https://raw.githubusercontent.com/macports/macports-ports/e83a55ef196d4283be438c052295b2fc44f3df5b/science/volk/files/patch-cpu_features-add-support-for-ARM64.diff";
      hash = "sha256-MNUntVvKZC4zuQsxGQCItaUaaQ1d31re2qjyPFbySmI=";
      extraPrefix = "";
    })
  ];

  cmakeFlags =
    [ (lib.cmakeBool "ENABLE_MODTOOL" enableModTool) ]
    ++ lib.optionals (stdenv.isDarwin && stdenv.isAarch64) [
      # offset 14335 in1: -1.03372 in2: -1.03371 tolerance was: 1e-05
      # volk_32f_log2_32f: fail on arch neon
      "-DCMAKE_CTEST_ARGUMENTS=--exclude-regex;qa_volk_32f_log2_32f"
    ];

  postInstall = lib.optionalString (!stdenv.isDarwin) ''
    remove-references-to -t ${stdenv.cc} $(readlink -f $out/lib/libvolk.so)
  '';

  nativeBuildInputs = [
    cmake
    # This version of the project wasn't updated to use Python 3.12 which
    # doesn't include the deprecated distutils module.
    python311
    python311.pkgs.mako
    removeReferencesTo
  ];

  doCheck = true;

  meta = {
    homepage = "http://libvolk.org/";
    description = "Vector Optimized Library of Kernels (version 2.5.0 - for GR 3.8)";
    license = lib.licenses.gpl3Plus;
    maintainers = with lib.maintainers; [ doronbehar ];
  };
})
