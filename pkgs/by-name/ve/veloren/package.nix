{
  lib,
  rustPlatform,
  fetchFromGitLab,
  pkg-config,
  vulkan-loader,
  alsa-lib,
  udev,
  shaderc,
  libxcb,
  libxkbcommon,
  autoPatchelfHook,
  libX11,
  libXi,
  libXcursor,
  libXrandr,
  wayland,
  stdenv,
}:

let
  # Note: use this to get the release metadata
  # https://gitlab.com/api/v4/projects/10174980/repository/tags/v{version}
  version = "0.17.0";
  date = "2024-12-28-12:49";
  rev = "a1be5a7bece7af43ebd76910eb0020c1cf3c0798";
in

rustPlatform.buildRustPackage {
  pname = "veloren";
  inherit version;

  src = fetchFromGitLab {
    owner = "veloren";
    repo = "veloren";
    inherit rev;
    hash = "sha256-AnmXn4GWzxu27FUyQIIVnANtu3sr0NIi7seN7buAtL8=";
  };

  cargoPatches = [
    ./fix-on-rust-stable.patch
    ./fix-assets-path.patch
  ];

  cargoHash = "sha256-Uj0gFcStWhIS+GbM/Hn/vD2PrA0ftzEnMnCwV0n0g7g=";

  postPatch = ''
    # Force vek to build in unstable mode
    cat <<'EOF' | tee "$cargoDepsCopy"/vek-*/build.rs
    fn main() {
      println!("cargo:rustc-check-cfg=cfg(nightly)");
      println!("cargo:rustc-cfg=nightly");
    }
    EOF
    # Fix assets path
    substituteAllInPlace common/assets/src/lib.rs
  '';

  nativeBuildInputs = [
    autoPatchelfHook
    pkg-config
  ];

  buildInputs = [
    alsa-lib
    udev
    libxcb
    libxkbcommon
    shaderc
    stdenv.cc.cc # libgcc_s.so.1
  ];

  buildNoDefaultFeatures = true;
  buildFeatures = [ "default-publish" ];

  env = {
    # Enable unstable features, see https://gitlab.com/veloren/veloren/-/issues/264
    RUSTC_BOOTSTRAP = true;

    # Set version info, required by veloren-common
    NIX_GIT_TAG = "v${version}";
    NIX_GIT_HASH = "${lib.substring 0 8 rev}/${date}";

    # Save game data under user's home directory,
    # otherwise it defaults to $out/bin/../userdata
    VELOREN_USERDATA_STRATEGY = "system";

    # Use system shaderc
    SHADERC_LIB_DIR = "${shaderc.lib}/lib";
  };

  # Some tests require internet access
  doCheck = false;

  appendRunpaths = [
    (lib.makeLibraryPath (
      [
        libX11
        libXi
        libXcursor
        libXrandr
        vulkan-loader
      ]
      ++ lib.optionals (lib.meta.availableOn stdenv.hostPlatform wayland) [
        wayland
      ]
    ))
  ];

  postInstall = ''
    # Icons
    install -Dm644 assets/voxygen/net.veloren.veloren.desktop -t "$out/share/applications"
    install -Dm644 assets/voxygen/net.veloren.veloren.png -t "$out/share/pixmaps"
    install -Dm644 assets/voxygen/net.veloren.veloren.metainfo.xml -t "$out/share/metainfo"
    # Assets directory
    mkdir -p "$out/share/veloren"; cp -ar assets "$out/share/veloren/"
  '';

  meta = {
    description = "Open world, open source voxel RPG";
    homepage = "https://www.veloren.net";
    license = lib.licenses.gpl3Only;
    mainProgram = "veloren-voxygen";
    platforms = lib.platforms.linux;
    maintainers = with lib.maintainers; [
      rnhmjoj
      tomodachi94
    ];
  };
}
