{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
  pkg-config,
  ispc,
  tbb,
  glfw,
  openimageio,
  libjpeg,
  libpng,
  libpthreadstubs,
  libX11,
  nix-update-script,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "embree";
  version = "2.17.4";

  src = fetchFromGitHub {
    owner = "embree";
    repo = "embree";
    tag = "v${finalAttrs.version}";
    sha256 = "0q3r724r58j4b6cbyy657fsb78z7a2c7d5mwdp7552skynsn2mn9";
  };

  cmakeFlags = [ "-DEMBREE_TUTORIALS=OFF" ];

  nativeBuildInputs = [
    cmake
    pkg-config
  ];
  buildInputs = [
    ispc
    tbb
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
  };

  meta = with lib; {
    description = "High performance ray tracing kernels from Intel";
    homepage = "https://embree.github.io/";
    maintainers = with maintainers; [ hodapp ];
    license = licenses.asl20;
    platforms = [ "x86_64-linux" ];
  };
})
