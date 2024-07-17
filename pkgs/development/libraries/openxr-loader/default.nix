{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
  python3,
  libX11,
  libXxf86vm,
  libXrandr,
  vulkan-headers,
  libGL,
  vulkan-loader,
  wayland,
  pkg-config,
}:

stdenv.mkDerivation rec {
  pname = "openxr-loader";
  version = "1.1.38";

  src = fetchFromGitHub {
    owner = "KhronosGroup";
    repo = "OpenXR-SDK-Source";
    rev = "release-${version}";
    sha256 = "sha256-nM/c6fvjprQ5GQO4F13cOigi4xATgRTq+ebEwyv58gg=";
  };

  nativeBuildInputs = [
    cmake
    python3
    pkg-config
  ];
  buildInputs = [
    libX11
    libXxf86vm
    libXrandr
    vulkan-headers
    libGL
    vulkan-loader
    wayland
  ];

  cmakeFlags = [ "-DBUILD_TESTS=ON" ];

  outputs = [
    "out"
    "dev"
    "layers"
  ];

  # https://github.com/KhronosGroup/OpenXR-SDK-Source/issues/305
  postPatch = ''
    substituteInPlace src/loader/openxr.pc.in \
      --replace '$'{exec_prefix}/@CMAKE_INSTALL_LIBDIR@ @CMAKE_INSTALL_FULL_LIBDIR@
  '';

  postInstall = ''
    mkdir -p "$layers/share"
    mv "$out/share/openxr" "$layers/share"
    # Use absolute paths in manifests so no LD_LIBRARY_PATH shenanigans are necessary
    for file in "$layers/share/openxr/1/api_layers/explicit.d/"*; do
        substituteInPlace "$file" --replace '"library_path": "lib' "\"library_path\": \"$layers/lib/lib"
    done
    mkdir -p "$layers/lib"
    mv "$out/lib/libXrApiLayer"* "$layers/lib"
  '';

  meta = with lib; {
    description = "Khronos OpenXR loader";
    homepage = "https://www.khronos.org/openxr";
    platforms = platforms.linux;
    license = licenses.asl20;
    maintainers = [ maintainers.ralith ];
  };
}
