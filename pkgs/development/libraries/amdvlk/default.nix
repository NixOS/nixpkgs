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

stdenv.mkDerivation rec {
  pname = "amdvlk";
  version = "2020.Q3.2";

  src = fetchRepoProject {
    name = "${pname}-src";
    manifest = "https://github.com/GPUOpen-Drivers/AMDVLK.git";
    rev = "refs/tags/v-${version}";
    sha256 = "1mki4lxy981g1rz9d6w18dv1hf3ldch5gld2vb7injn5ipp6z2y3";
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

  installPhase = ''
    install -Dm755 -t $out/lib icd/amdvlk64.so
    install -Dm644 -t $out/share/vulkan/icd.d ../drivers/AMDVLK/json/Redhat/amd_icd64.json

    substituteInPlace $out/share/vulkan/icd.d/amd_icd64.json --replace \
      "/usr/lib64" "$out/lib"

    patchelf --set-rpath "$rpath" $out/lib/amdvlk64.so
  '';

  # Keep the rpath, otherwise vulkaninfo and vkcube segfault
  dontPatchELF = true;

  meta = with stdenv.lib; {
    description = "AMD Open Source Driver For Vulkan";
    homepage = "https://github.com/GPUOpen-Drivers/AMDVLK";
    license = licenses.mit;
    platforms = [ "x86_64-linux" ];
    maintainers = with maintainers; [ Flakebi ];
  };
}
