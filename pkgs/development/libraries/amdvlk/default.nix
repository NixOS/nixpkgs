{ stdenv
, lib
, fetchRepoProject
, cmake
, ninja
, patchelf
, perl
, pkg-config
, python3
, expat
, libdrm
, ncurses
, openssl
, wayland
, xorg
, zlib
}:
let

  suffix = if stdenv.system == "x86_64-linux" then "64" else "32";

in stdenv.mkDerivation rec {
  pname = "amdvlk";
  version = "2021.Q3.7";

  src = fetchRepoProject {
    name = "${pname}-src";
    manifest = "https://github.com/GPUOpen-Drivers/AMDVLK.git";
    rev = "refs/tags/v-${version}";
    sha256 = "sha256-0Q6c10lQSxgqOB6X6F8LyeF2aoyicmp0tZlknuZjQHE=";
  };

  buildInputs = [
    expat
    ncurses
    openssl
    wayland
    xorg.libX11
    xorg.libxcb
    xorg.xcbproto
    xorg.libXext
    xorg.libXrandr
    xorg.libXft
    xorg.libxshmfence
    zlib
  ];

  nativeBuildInputs = [
    cmake
    ninja
    patchelf
    perl
    pkg-config
    python3
  ];

  rpath = lib.makeLibraryPath [
    libdrm
    openssl
    stdenv.cc.cc.lib
    xorg.libX11
    xorg.libxcb
    xorg.libxshmfence
  ];

  cmakeDir = "../drivers/xgl";

  installPhase = ''
    install -Dm755 -t $out/lib icd/amdvlk${suffix}.so
    install -Dm644 -t $out/share/vulkan/icd.d icd/amd_icd${suffix}.json
    install -Dm644 -t $out/share/vulkan/implicit_layer.d icd/amd_icd${suffix}.json

    patchelf --set-rpath "$rpath" $out/lib/amdvlk${suffix}.so
  '';

  # Keep the rpath, otherwise vulkaninfo and vkcube segfault
  dontPatchELF = true;

  meta = with lib; {
    description = "AMD Open Source Driver For Vulkan";
    homepage = "https://github.com/GPUOpen-Drivers/AMDVLK";
    changelog = "https://github.com/GPUOpen-Drivers/AMDVLK/releases/tag/v-${version}";
    license = licenses.mit;
    platforms = [ "x86_64-linux" "i686-linux" ];
    maintainers = with maintainers; [ Flakebi ];
  };
}
