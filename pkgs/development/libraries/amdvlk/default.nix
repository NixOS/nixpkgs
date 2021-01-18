{ stdenv
, lib
, fetchRepoProject
, cmake
, ninja
, patchelf
, perl
, pkgconfig
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
  version = "2020.Q4.6";

  src = fetchRepoProject {
    name = "${pname}-src";
    manifest = "https://github.com/GPUOpen-Drivers/AMDVLK.git";
    rev = "refs/tags/v-${version}";
    sha256 = "wminJxfku8Myag+SI7iLSvS+VzHlUd4c86BbpF/cr1w=";
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
    pkgconfig
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

  # LTO is disabled in gcc for i686 as of #66528
  cmakeFlags = stdenv.lib.optionals stdenv.is32bit ["-DXGL_ENABLE_LTO=OFF"];

  installPhase = ''
    install -Dm755 -t $out/lib icd/amdvlk${suffix}.so
    install -Dm644 -t $out/share/vulkan/icd.d ../drivers/AMDVLK/json/Redhat/amd_icd${suffix}.json

    substituteInPlace $out/share/vulkan/icd.d/amd_icd${suffix}.json --replace \
      "/usr/lib64" "$out/lib"
    substituteInPlace $out/share/vulkan/icd.d/amd_icd${suffix}.json --replace \
      "/usr/lib" "$out/lib"

    patchelf --set-rpath "$rpath" $out/lib/amdvlk${suffix}.so
  '';

  # Keep the rpath, otherwise vulkaninfo and vkcube segfault
  dontPatchELF = true;

  meta = with stdenv.lib; {
    description = "AMD Open Source Driver For Vulkan";
    homepage = "https://github.com/GPUOpen-Drivers/AMDVLK";
    changelog = "https://github.com/GPUOpen-Drivers/AMDVLK/releases/tag/v-${version}";
    license = licenses.mit;
    platforms = [ "x86_64-linux" "i686-linux" ];
    maintainers = with maintainers; [ danieldk Flakebi ];
  };
}
