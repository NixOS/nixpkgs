{
  lib,
  rustPlatform,
  fetchFromGitLab,
  pkg-config,
  python3,
  cmake,
  m4,
  harfbuzz,
  dbus,
  gst_all_1,
  libunwind,
  gnumake,
  fontconfig,
  llvmPackages_14,
  openssl,
  xorg,
  zlib,
  libxkbcommon,
  vulkan-loader,
  wayland,
  libGL,
  yasm,
  mold,
  freetype,
  taplo,
}:
let
  llvmPackages = llvmPackages_14;
in
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

  # set `HOME` to a temp dir for write access
  # Fix invalid option errors during linking (https://github.com/mozilla/nixpkgs-mozilla/commit/c72ff151a3e25f14182569679ed4cd22ef352328)
  preConfigure = ''
    export HOME=$TMPDIR
    unset AS
  '';

  env.LIBCLANG_PATH = "${llvmPackages.libclang.lib}/lib";
  env.LD_LIBRARY_PATH = lib.makeLibraryPath [
    zlib
    xorg.libXcursor
    xorg.libXrandr
    xorg.libXi
    libxkbcommon
    vulkan-loader
    wayland
    libGL
  ];

  nativeBuildInputs = [
    llvmPackages.bintools-unwrapped
    llvmPackages.llvm
    rustPlatform.bindgenHook
    llvmPackages.libclang
    gnumake
    m4
    pkg-config
    llvmPackages.libstdcxxClang
    (python3.withPackages (
      ps: with ps; [
        webidl
        pip
        mako
      ]
    ))
  ];

  buildInputs = [
    # llvmPackages.bintools
    llvmPackages.libstdcxxClang
    llvmPackages.llvm
    # dbus
    llvmPackages.libclang
    (python3.withPackages (
      ps: with ps; [
        webidl
        pip
        mako
      ]
    ))
    harfbuzz
    xorg.libxcb
    xorg.libX11
    gst_all_1.gstreamer
    gst_all_1.gst-plugins-base
    gst_all_1.gst-plugins-good
    gst_all_1.gst-plugins-bad
    gst_all_1.gst-plugins-ugly
    fontconfig
    libunwind
    freetype
    taplo
    libGL
    openssl
    llvmPackages.llvm
    wayland
    yasm
  ];

  doCheck = false;

})
