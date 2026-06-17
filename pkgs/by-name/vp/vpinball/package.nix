{
  lib,
  stdenv,
  callPackage,
  fetchFromGitHub,
  runCommand,
  cmake,
  pkg-config,
  makeWrapper,
  perl,
  addDriverRunpath,
  zlib,
  libdrm,
  libGL,
  libGLU,
  libglvnd,
  vulkan-loader,
  wayland,
  wayland-protocols,
  libxkbcommon,
  systemd,
  alsa-lib,
  pipewire,
  libx11,
  libxext,
  libxcursor,
  libxcb,
  libxi,
  libxscrnsaver,
  libxtst,
  libxrandr,
  libxrender,
  libxfixes,
}:

let
  version = "10.8.1-unstable-2026-06-15";

  sources = callPackage ./sources.nix { };
  externals = callPackage ./externals.nix { inherit sources; };

  runtimeLibraryPath = lib.makeLibraryPath [
    vulkan-loader
    libglvnd
    libx11
    libxcb
    pipewire
    alsa-lib
    wayland
  ];
in
stdenv.mkDerivation (finalAttrs: {
  pname = "vpinball";
  inherit version;

  strictDeps = true;
  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "vpinball";
    repo = "vpinball";
    rev = "2c83fd2249c4406f15232ce6b6d6d4f913fd7883";
    hash = "sha256-xh8IQknCvZAta3Lv6yuwq7yxsbgOBjRgMduBNGxQdTM=";
  };

  nativeBuildInputs = [
    cmake
    pkg-config
    makeWrapper
    perl
  ];

  buildInputs = [
    zlib
    libdrm
    libGL
    libGLU
    libglvnd
    vulkan-loader
    wayland
    wayland-protocols
    libxkbcommon
    systemd
    alsa-lib
    pipewire
    libx11
    libxext
    libxcursor
    libxcb
    libxi
    libxscrnsaver
    libxtst
    libxrandr
    libxrender
    libxfixes
  ];

  preConfigure = ''
    cp make/CMakeLists_bgfx-linux-x64.txt CMakeLists.txt

    if [ ! -d "${externals}/third-party/include" ]; then
      echo "vpinball externals are missing: ${externals}" >&2
      exit 1
    fi

    chmod -R u+w third-party
    cp -a "${externals}/third-party/." third-party/
  '';

  cmakeFlags = [
    "-DCMAKE_BUILD_TYPE=Release"
  ];

  installPhase = ''
    runHook preInstall

    mkdir -p "$out/bin" "$out/lib/vpinball"

    cp -a VPinballX_BGFX "$out/lib/vpinball/"
    cp -a ./*.so ./*.so.* "$out/lib/vpinball/"
    cp -a assets scripts docs plugins "$out/lib/vpinball/"

    makeWrapper "$out/lib/vpinball/VPinballX_BGFX" "$out/bin/vpinball" \
      --set-default SDL_AUDIODRIVER alsa \
      --prefix LD_LIBRARY_PATH : "${addDriverRunpath.driverLink}/lib:${runtimeLibraryPath}:$out/lib/vpinball"

    runHook postInstall
  '';

  passthru.tests.smoke =
    runCommand "${finalAttrs.pname}-smoke-test" { nativeBuildInputs = [ finalAttrs.finalPackage ]; }
      ''
        export HOME="$TMPDIR/home"
        export XDG_CONFIG_HOME="$TMPDIR/config"
        export XDG_DATA_HOME="$TMPDIR/share"
        export SDL_AUDIODRIVER=dummy
        export SDL_VIDEODRIVER=dummy

        mkdir -p "$HOME" "$XDG_CONFIG_HOME" "$XDG_DATA_HOME"

        vpinball -h > "$out"
        grep -q "Visual Pinball Usage" "$out"
      '';

  meta = {
    description = "Visual Pinball standalone player";
    homepage = "https://github.com/vpinball/vpinball";
    # Upstream is migrating from an old MAME-like noncommercial license to
    # GPLv3+, while bundled third-party components retain their own licenses.
    license = with lib.licenses; [
      gpl3Plus
      unfreeRedistributable
    ];
    mainProgram = "vpinball";
    maintainers = with lib.maintainers; [ nmoya ];
    platforms = [ "x86_64-linux" ];
  };
})
