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

let
  # Note: use this to get the release metadata
  # https://gitlab.com/api/v4/projects/10174980/repository/tags/v{version}
  version = "0.16.0";
  date = "2023-03-30-03:28";
  rev = "80fe5ca64b40fbf3e0e393a44f8880a79a6a5380";
in

rustPlatform.buildRustPackage {
  pname = "veloren";
  inherit version;

  src = fetchFromGitLab {
    owner = "veloren";
    repo = "veloren";
    inherit rev;
    hash = "sha256-h2hLO227aeK2oEFfdGMgmtMkA9cn9AgQ9w6myb+8W8c=";
  };

  cargoPatches = [
    ./fix-on-rust-stable.patch
    ./fix-assets-path.patch
  ];

  cargoHash = "sha256-3XHuAgue0Id1oxCJ8NLZ4wYjMfND+C1iIW+AnMKXd54=";

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
    NIX_GIT_TAG = "v${version}";
    NIX_GIT_HASH = "${lib.substring 0 7 rev}/${date}";

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
    install -Dm644 assets/voxygen/net.veloren.veloren.png "$out/share/pixmaps"
    install -Dm644 assets/voxygen/net.veloren.veloren.metainfo.xml "$out/share/metainfo"
    # Assets directory
    mkdir -p "$out/share/veloren"; cp -ar assets "$out/share/veloren/"
  '';

  meta = with lib; {
    description = "Open world, open source voxel RPG";
    homepage = "https://www.veloren.net";
    license = licenses.gpl3;
    mainProgram = "veloren-voxygen";
    platforms = platforms.linux;
    maintainers = with maintainers; [
      rnhmjoj
      tomodachi94
    ];
  };
}
