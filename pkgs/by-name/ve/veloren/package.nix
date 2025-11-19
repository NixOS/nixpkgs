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
  mold,
}:

let
  # Note: use this to get the release metadata
  # https://gitlab.com/api/v4/projects/10174980/repository/tags/nightly
  version = "0-unstable-2025-11-16";
  date = "2025-11-16-13:54";
  rev = "378d14f5403a7e682ffe9d55a7e5dae5e6a736d7";

  src = fetchFromGitLab {
    owner = "veloren";
    repo = "veloren";
    inherit rev;
    hash = "sha256-PBCWR9NNwfM0qX9+c8ZwnS3aFnEezkpJ1UTPSUn25/w=";
  };
in

rustPlatform.buildRustPackage {
  pname = "veloren";
  inherit version src;

  cargoPatches = [
    ./fix-assets-path.patch
  ];

  cargoHash = "sha256-2gx7LqYe55pcGkmdn5OQgG3G9iSNjdn1t2Du4OOKoGE=";

  postPatch = ''
    # Force vek to build in unstable mode
    cat <<'EOF' | tee "$cargoDepsCopy"/vek-*/build.rs
    fn main() {
      println!("cargo:rustc-check-cfg=cfg(nightly)");
      println!("cargo:rustc-cfg=nightly");
    }
    EOF
    # Use env var for null sound path
    sed -i 's:"../../../assets/voxygen/audio/null.ogg":env!("VOXYGEN_NULL_SOUND_PATH"):' \
      voxygen/src/audio/soundcache.rs
    # Fix assets path
    substituteAllInPlace common/assets/src/lib.rs
  '';

  nativeBuildInputs = [
    autoPatchelfHook
    pkg-config
    mold
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

    # Path to null sound file for voxygen
    VOXYGEN_NULL_SOUND_PATH = "${src}/assets/voxygen/audio/null.ogg";
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
