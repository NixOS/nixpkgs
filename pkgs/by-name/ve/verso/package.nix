{
  lib,
  stdenv,
  rustPlatform,
  fetchFromGitLab,
  unstableGitUpdater,

  llvmPackages_14,
  m4,
  pkg-config,
  python3,
  wrapGAppsHook3,
  writableTmpDirAsHomeHook,

  apple-sdk_14,
  fontconfig,
  gst_all_1,
  libGL,
  libunwind,
  libxkbcommon,
  openssl,
  wayland,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "verso";
  version = "0-unstable-2025-06-15";

  src = fetchFromGitLab {
    owner = "verso-browser";
    repo = "verso";
    rev = "ace264e0e73da37bfb14818d92f0e54946ce9871";
    hash = "sha256-gjg7qs2ik1cJcE6OTGN4KdljqJDGokCo4JdR+KopMJw=";
  };

  depsExtraArgs = {
    # The vendoring process copies subdirectories, but there are some files that
    # try to read files from their parent directories during build time
    # We avoid this issue by placing the used file into the subdirectory
    postBuild = ''
      pushd $out/git/*/components/net
      cp ../../resources/rippy.png ./rippy.png
      substituteInPlace image_cache.rs \
        --replace-fail '../../resources/rippy.png' './rippy.png'
      popd
    '';
  };

  cargoHash = "sha256-dYsqr9c5n2lDt1K9EpAzkJXwmr2eJ+ExT53dlTEYraY=";

  postPatch = ''
    # The original script assumes things about the directory layout of the build
    substituteInPlace "$cargoDepsCopy"/script_bindings-*/codegen/run.py --replace-fail \
      "SERVO_ROOT =" \
      "SERVO_ROOT = '$(pwd)' #"

    # Set a better default resource directory search path
    substituteInPlace src/config.rs --replace-fail \
      "let root_dir = std::env::current_dir()" \
      "let root_dir = { use std::str::FromStr; std::path::PathBuf::from_str(\"$out/share/verso\") }"

    # This is not actually needed since we have the "versoview" binary placed
    # right next to verso, but it's better to be safe
    substituteInPlace verso/src/main.rs --replace-fail \
      "let versoview_path = current_exe().unwrap().parent().unwrap().join(\"versoview\");" \
      "let versoview_path = std::path::Path::new(\"$out/bin/versoview\");"
  '';

  # Fix invalid option errors during linking
  # https://github.com/mozilla/nixpkgs-mozilla/commit/c72ff151a3e25f14182569679ed4cd22ef352328
  preConfigure = ''
    unset AS
  '';

  env.RUSTC_BOOTSTRAP = 1;

  cargoBuildFlags = [
    "-p=versoview"
    "-p=verso"
  ];

  nativeBuildInputs = [
    llvmPackages_14.llvm
    m4
    python3
    rustPlatform.bindgenHook
    writableTmpDirAsHomeHook
  ]
  ++ lib.optionals stdenv.hostPlatform.isLinux [
    pkg-config
    wrapGAppsHook3
  ];

  buildInputs =
    lib.optionals stdenv.hostPlatform.isLinux [
      fontconfig
      gst_all_1.gstreamer
      gst_all_1.gst-plugins-base
      gst_all_1.gst-plugins-good
      gst_all_1.gst-plugins-bad
      gst_all_1.gst-plugins-ugly
      libunwind
      openssl
    ]
    ++ lib.optionals stdenv.hostPlatform.isDarwin [
      apple-sdk_14
    ];

  # Note: it might be better to disable automatic wrapping and only wrap versoview
  # Note: using patchelf --add-rpath in postFixup could be better than setting LD_LIBRARY_PATH
  preFixup = lib.optionalString stdenv.hostPlatform.isLinux ''
    gappsWrapperArgs+=(
      --prefix LD_LIBRARY_PATH : ${
        lib.makeLibraryPath [
          libGL
          libxkbcommon
          wayland
        ]
      }
    )
  '';

  postInstall = ''
    install -Dm644 org.versotile.verso.desktop $out/share/applications/org.versotile.verso.desktop
    install -Dm644 icons/icon256x256.png $out/share/icons/hicolor/256x256/apps/org.versotile.verso.png

    # Install the resource directory into our patched default location
    mkdir -p "$out/share/verso"
    cp -r ./resources "$out/share/verso/resources"
  '';

  # checks fail to compile due to vendoring issues
  doCheck = false;

  passthru.updateScript = unstableGitUpdater { };

  meta = {
    description = "Web browser built on top of the Servo web engine";
    homepage = "https://gitlab.com/verso-browser/verso";
    downloadPage = "https://gitlab.com/verso-browser/verso";
    license = with lib.licenses; [
      asl20
      mit
    ];
    maintainers = with lib.maintainers; [
      ethancedwards8
      tomasajt
    ];
    teams = [ lib.teams.ngi ];
    platforms = lib.platforms.linux ++ lib.platforms.darwin;
  };
})
