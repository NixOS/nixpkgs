{ stdenv
, callPackage
, lib
, fetchRepoProject
, writeScript
, cmake
, directx-shader-compiler
, glslang
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
  version = "2023.Q3.1";

  src = fetchRepoProject {
    name = "${pname}-src";
    manifest = "https://github.com/GPUOpen-Drivers/AMDVLK.git";
    rev = "refs/tags/v-${version}";
    sha256 = "W+igZbdQG1L62oGJa2Rz0n8YkTsZFqSm7w8VFfPu8k0=";
  };

  buildInputs = [
    expat
    libdrm
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
    directx-shader-compiler
    glslang
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
    zlib
  ];

  cmakeDir = "../drivers/xgl";

  installPhase = ''
    runHook preInstall

    install -Dm755 -t $out/lib icd/amdvlk${suffix}.so
    install -Dm644 -t $out/share/vulkan/icd.d icd/amd_icd${suffix}.json
    install -Dm644 -t $out/share/vulkan/implicit_layer.d icd/amd_icd${suffix}.json

    patchelf --set-rpath "$rpath" $out/lib/amdvlk${suffix}.so

    runHook postInstall
  '';

  # Keep the rpath, otherwise vulkaninfo and vkcube segfault
  dontPatchELF = true;

  passthru.updateScript = writeScript "update.sh" ''
    #!/usr/bin/env nix-shell
    #!nix-shell -i bash -p coreutils curl gnused jq common-updater-scripts

    function setHash() {
      sed -i "pkgs/development/libraries/amdvlk/default.nix" -e 's,sha256 = "[^'"'"'"]*",sha256 = "'"$1"'",'
    }

    version="$(curl -sL "https://api.github.com/repos/GPUOpen-Drivers/AMDVLK/releases?per_page=1" | jq '.[0].tag_name | split("-") | .[1]' --raw-output)"
    sed -i "pkgs/development/libraries/amdvlk/default.nix" -e 's/version = "[^'"'"'"]*"/version = "'"$version"'"/'

    setHash "$(nix-instantiate --eval -A lib.fakeSha256 | xargs echo)"
    hash="$(nix to-base64 $(nix-build -A amdvlk 2>&1 | tail -n3 | grep 'got:' | cut -d: -f2- | xargs echo || true))"
    setHash "$hash"
  '';

  passthru.impureTests = { amdvlk = callPackage ./test.nix {}; };

  meta = with lib; {
    description = "AMD Open Source Driver For Vulkan";
    homepage = "https://github.com/GPUOpen-Drivers/AMDVLK";
    changelog = "https://github.com/GPUOpen-Drivers/AMDVLK/releases/tag/v-${version}";
    license = licenses.mit;
    platforms = [ "x86_64-linux" "i686-linux" ];
    maintainers = with maintainers; [ Flakebi ];
  };
}
