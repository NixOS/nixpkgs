{
  lib,
  rustPlatform,
  fetchFromGitLab,
  pkg-config,
  vulkan-loader,
  alsa-lib,
  udev,
  shaderc,
  xorg,
  libxkbcommon,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "veloren";
  version = "0.17.0";

  src = fetchFromGitLab {
    owner = "veloren";
    repo = "veloren";
    tag = "v${finalAttrs.version}";
    hash = "sha256-AnmXn4GWzxu27FUyQIIVnANtu3sr0NIi7seN7buAtL8=";
  };

  # cargoLock.lockFile = ./Cargo.lock;
  # cargoLock.outputHashes = {
  #   # Hashes of dependencies pinned to a git commit
  #   "auth-common-0.1.0" = "sha256-6tUutHLY309xSBT2D7YueAmsAWyVn410XNKFT8yuTgA=";
  #   "conrod_core-0.63.0" = "sha256-GxakbJBVTFgbtUsa2QB105xgd+aULuWLBlv719MIzQY=";
  #   "egui_wgpu_backend-0.26.0" = "sha256-47XZoE7bFRv/TG4EmM2qit5L21qsKT6Nt/t1y/NMneQ=";
  #   "fluent-0.16.0" = "sha256-xN+DwObqoToqprLDy3yvTiqclIIOsuUtpAQ6W1mdf0I=";
  #   "iced_core-0.4.0" = "sha256-5s6IXcitoGcHS0FUx/cujx9KLBpaUuMnugmBged1cLA=";
  #   "keyboard-keynames-0.1.2" = "sha256-5I70zT+Lwt0JXJgTAy/VygHdxIBuE/u3pq8LP8NkRdE=";
  #   "naga-0.14.2" = "sha256-yyLrJNhbu/RIVr0hM7D7Rwd7vH3xX8Dns+u6m8NEU2M=";
  #   "portpicker-0.1.0" = "sha256-or1907XdrDIyFzHNmW6me2EIyEQ8sjVIowfGsypa4jU=";
  #   "shaderc-0.8.0" = "sha256-BU736g075i3GqlyyB9oyoVlQqNcWbZEGa8cdge1aMq0=";
  #   "specs-0.20.0" = "sha256-OHnlag6SJ1rlAYnlmVD+uqY+kFNsbQ42W21RrEa8Xn0=";
  # };
  cargoPatches = [
    # ./fix-on-rust-stable.patch
    ./fix-assets-path.patch
  ];

  useFetchCargoVendor = true;
  cargoHash = "sha256-oUoLKxdAI149e97Kgc1lOKj5UwI97hzmcESXlvllGyg=";

  # Use our Cargo.lock
  # cp ${./Cargo.lock} Cargo.lock

  postPatch = ''
    # Force vek to build in unstable mode
    cat <<'EOF' | tee "$cargoDepsCopy"/vek-*/build.rs
    fn main() {
      println!("cargo:rustc-check-cfg=cfg(nightly)");
      println!("cargo:rustc-cfg=nightly");
    }
    EOF
  '';

  nativeBuildInputs = [ pkg-config ];
  buildInputs = [
    alsa-lib
    udev
    xorg.libxcb
    libxkbcommon
  ];

  buildNoDefaultFeatures = true;
  buildFeatures = [ "default-publish" ];

  env = {
    # Enable unstable features, see https://gitlab.com/veloren/veloren/-/issues/264
    RUSTC_BOOTSTRAP = true;

    # Set version info, required by veloren-common
    NIX_GIT_TAG = "v${finalAttrs.version}";
    NIX_GIT_HASH = "00000000";
    # NIX_GIT_HASH = "${lib.substring 0 7 rev}/${date}";

    # Save game data under user's home directory,
    # otherwise it defaults to $out/bin/../userdata
    VELOREN_USERDATA_STRATEGY = "system";

    # Use system shaderc
    SHADERC_LIB_DIR = "${shaderc.lib}/lib";
  };

  # Some tests require internet access
  doCheck = false;

  postFixup = ''
    # Add required but not explicitly requested libraries
    patchelf --add-rpath '${
      lib.makeLibraryPath [
        xorg.libX11
        xorg.libXi
        xorg.libXcursor
        xorg.libXrandr
        vulkan-loader
      ]
    }' "$out/bin/veloren-voxygen"
  '';

  postInstall = ''
    # Icons
    install -Dm644 assets/voxygen/net.veloren.veloren.desktop -t "$out/share/applications"
    install -Dm644 assets/voxygen/net.veloren.veloren.metainfo.xml -t "$out/share/metainfo"
    install -Dm644 assets/voxygen/net.veloren.veloren.png -t "$out/share/pixmaps"
    # Assets directory
    mkdir -p "$out/share/veloren"; cp -ar assets "$out/share/veloren/"
  '';

  meta = {
    description = "Open world, open source voxel RPG";
    homepage = "https://www.veloren.net";
    changelog = "https://gitlab.com/veloren/veloren/-/blob/v${finalAttrs.version}/CHANGELOG.md?ref_type=tags";
    license = lib.licenses.gpl3;
    mainProgram = "veloren-voxygen";
    platforms = lib.platforms.linux;
    maintainers = with lib.maintainers; [
      rnhmjoj
      tomodachi94
    ];
  };
})
