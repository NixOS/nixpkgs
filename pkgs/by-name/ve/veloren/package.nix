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
  libx11,
  libxi,
  libxcursor,
  libxrandr,
  wayland,
  stdenv,
}:

let
  # Note: use this to get the release metadata
  # https://gitlab.com/api/v4/projects/10174980/repository/tags/v{version}
  version = "0.18.0";
  timestamp = "1769191511";
  rev = "1d12f35edd6cdbfc1fb921c167cdd7beeeffe248";
in

rustPlatform.buildRustPackage {
  pname = "veloren";
  inherit version;

  src = fetchFromGitLab {
    owner = "veloren";
    repo = "veloren";
    inherit rev;
    hash = "sha256-tngIwFq18kvOU2XwCQoeLWjiVDjrJgOf3XIYz2J2cWs=";
  };

  cargoPatches = [
    ./fix-assets-path.patch
  ];

  cargoHash = "sha256-1qLE1UeP2i0xaOGLniZzdjIkBbme6rctGfcO9Kfoh5E=";

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
    # Do not use mold, it produces broken binaries
    substituteInPlace .cargo/config.toml --replace-fail mold gold
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
    VELOREN_GIT_VERSION = "/${lib.substring 0 8 rev}/${timestamp}";

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
        libx11
        libxi
        libxcursor
        libxrandr
        libxkbcommon
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
    install -Dm644 assets/voxygen/net.veloren.veloren.png -t "$out/share/icons/hicolor/256x256/apps"
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
