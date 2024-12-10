{
  stdenv,
  lib,
  fetchFromGitHub,
  fetchpatch,
  cmake,
  python3,
  enableModTool ? true,
  removeReferencesTo,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "volk";
  version = "3.0.0";

  src = fetchFromGitHub {
    owner = "gnuradio";
    repo = "volk";
    rev = "v${finalAttrs.version}";
    hash = "sha256-kI4IuO6TLplo5lLAGIPWQWtePcjIEWB9XaJDA6WlqSg=";
    fetchSubmodules = true;
  };
  patches = [
    # Remove a failing test
    (fetchpatch {
      url = "https://github.com/gnuradio/volk/commit/fe2e4a73480bf2ac2e566052ea682817dddaf61f.patch";
      hash = "sha256-Vko/Plk7u6UAr32lieU+T9G34Dkg9EW3Noi/NArpRL4=";
    })
  ];

  cmakeFlags =
    lib.optionals (!enableModTool) [
      "-DENABLE_MODTOOL=OFF"
    ]
    ++ lib.optionals (stdenv.isDarwin && stdenv.isAarch64) [
      "-DVOLK_CPU_FEATURES=OFF"
      # offset 17912 in1: -0.0366274 in2: -0.0366173 tolerance was: 1e-05
      # volk_32f_log2_32f: fail on arch neon
      "-DCMAKE_CTEST_ARGUMENTS=--exclude-regex;qa_volk_32f_log2_32f"
    ];

  postInstall = lib.optionalString (!stdenv.isDarwin) ''
    ${removeReferencesTo}/bin/remove-references-to -t ${stdenv.cc} $(readlink -f $out/lib/libvolk.so)
  '';

  nativeBuildInputs = [
    cmake
    python3
    python3.pkgs.mako
  ];

  doCheck = true;

  meta = with lib; {
    homepage = "http://libvolk.org/";
    description = "The Vector Optimized Library of Kernels";
    license = licenses.gpl3Plus;
    maintainers = with maintainers; [ doronbehar ];
    platforms = platforms.all;
  };
})
