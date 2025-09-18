{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
  pkg-config,
  ispc,
  tbb_2020,
  glfw,
  openimageio,
  libjpeg,
  libpng,
  libpthreadstubs,
  libX11,
  python3Packages,
  nix-update-script,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "embree";
  version = "2.17.7";

  src = fetchFromGitHub {
    owner = "embree";
    repo = "embree";
    tag = "v${finalAttrs.version}";
    hash = "sha256-FD/ITZBJnYy1F+x4jLTVTsGsNKy/mS7OYWP06NoHZqc=";
  };

  cmakeFlags = [ "-DEMBREE_TUTORIALS=OFF" ];

  nativeBuildInputs = [
    cmake
    pkg-config
  ];
  buildInputs = [
    ispc
    # tbb_2022 is not backward compatible
    tbb_2020
    glfw
    openimageio
    libjpeg
    libpng
    libX11
    libpthreadstubs
  ];

  passthru = {
    updateScript = nix-update-script {
      extraArgs = [
        "--version-regex"
        "v(2.*)"
      ];
    };
    tbb = tbb_2020;
    tests = {
      inherit (python3Packages) embreex;
    };
  };

  meta = with lib; {
    description = "High performance ray tracing kernels from Intel";
    homepage = "https://embree.github.io/";
    maintainers = with maintainers; [
      hodapp
      pbsds
    ];
    license = licenses.asl20;
    platforms = [ "x86_64-linux" ];
  };
})
