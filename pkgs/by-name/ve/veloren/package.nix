{ lib
, rustPlatform
, fetchFromGitLab
, runCommandLocal
, pkg-config
, vulkan-loader
, alsa-lib
, udev
, shaderc
, xorg
, libxkbcommon
}:

let
  # Note: use this to get the release metadata
  # https://gitlab.com/api/v4/projects/10174980/repository/tags/v{version}
  version = "0.15.0";
  date = "2023-06-30-15:09";
  rev = "75c3b8ca659b6b740ebea8db46d2ebccb5bac6c6";

  src = fetchFromGitLab {
    owner = "veloren";
    repo = "veloren";
    inherit rev;
    hash = "sha256-TKs/WT5S1hUBd9Y7AivFwbhlMI92GA5Auaevrjnx1cE=";
  };

  # Game assets, should not to be cached by hydra
  assets = lib.dontDistribute (runCommandLocal "veloren-assets" {} ''
    mkdir -p "$out/share/veloren"
    cp -r '${src}/assets' "$out/share/veloren"
  '');
in

rustPlatform.buildRustPackage {
  pname = "veloren";
  inherit src version;

  cargoLock.lockFile = ./Cargo.lock;
  cargoLock.outputHashes = {
    # Hashes of dependencies pinned to a git commit
    "auth-common-0.1.0" = "sha256-hL/2eAf34XluXYKRopr4Gc/Ei10oZkPPFd3iEm3A3Fs=";
    "conrod_core-0.63.0" = "sha256-GxakbJBVTFgbtUsa2QB105xgd+aULuWLBlv719MIzQY=";
    "egui_wgpu_backend-0.8.0" = "sha256-mBRiTuc9gv3CGCMqsjSdFUfJNsCxF4k5sxA87ldSg0o=";
    "fluent-0.16.0" = "sha256-xN+DwObqoToqprLDy3yvTiqclIIOsuUtpAQ6W1mdf0I=";
    "gfx-auxil-0.9.0" = "sha256-87vah/PGq9kQs/KhZdxdjZ5xejDu+JdwqLOrVlJ4KRI=";
    "iced_core-0.4.0" = "sha256-3vtTwPhJHKcvS6hcJb/NS5iTObcOxeUZd8KyYV77WY0=";
    "naga-0.4.0" = "sha256-826hvOOi1kO1zw2auS9auKDGp046KS1dpCi+3a4LQ2c=";
    "ntapi-0.3.7" = "sha256-nPerpNOMO+dRb7rrgiaYaSIaRiSPZzGy3a4C2a3iQsM=";
    "portpicker-0.1.0" = "sha256-or1907XdrDIyFzHNmW6me2EIyEQ8sjVIowfGsypa4jU=";
    "shaderc-0.8.0" = "sha256-BU736g075i3GqlyyB9oyoVlQqNcWbZEGa8cdge1aMq0=";
    "tui-0.10.0" = "sha256-v6e2EG073oyMgJzjw6mzVL5bRlTQ+li3y1nKCcHVI2o=";
    "vek-0.15.8" = "sha256-JaL1oHJZUsVBRaIlp1Tu+c3KMbRS3NoxWvNgMYgOx1A=";
    "wgpu-0.8.0" = "sha256-tNlOoWD7YTdzEaSEvYVSNrC1FguHCGPPLgCs1vCqKnU=";
    "wgpu-profiler-0.4.0" = "sha256-SDEeee/RqYih2CHY4n9cxSdkq2upl2jLEWqC4gkDCt4=";
  };

  patches = [
    ./fix-on-rust-stable.patch
    ./fix-system-assets.patch
  ];

  postPatch = ''
    # Patch cargo dependencies
    patch "$cargoDepsCopy/vek-0.15.8/build.rs" '${./fix-vek-on-stable.patch}'
    # Set the default assets path
    substituteInPlace common/assets/src/lib.rs --subst-var-by assets '${assets}'
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
    SHADERC_LIB_DIR="${shaderc.lib}/lib";
  };

  # Some tests require internet access
  doCheck = false;

  postFixup = ''
    # Add required but not explicitly requested libraries
    patchelf --add-rpath '${lib.makeLibraryPath [
      xorg.libX11
      xorg.libXi
      xorg.libXcursor
      xorg.libXrandr
      vulkan-loader
    ]}' "$out/bin/veloren-voxygen"
  '';

  postInstall = ''
    install -Dm644 assets/voxygen/net.veloren.veloren.desktop -t "$out/share/applications"
    install -Dm644 assets/voxygen/net.veloren.veloren.png "$out/share/pixmaps"
    install -Dm644 assets/voxygen/net.veloren.veloren.metainfo.xml "$out/share/metainfo"
  '';

  passthru.assets = assets;

  meta = with lib; {
    description = "An open world, open source voxel RPG";
    homepage = "https://www.veloren.net";
    license = licenses.gpl3;
    mainProgram = "veloren-voxygen";
    platforms = platforms.linux;
    maintainers = with maintainers; [ rnhmjoj ];
  };
}
