{
  lib,
  rustPlatform,
  fetchFromGitLab,
  pkg-config,
  python3,
  dbus,
  mako,
  m4,
  libunwind,
  writableTmpDirAsHomeHook,
  fontconfig,
  llvmPackages,
  openssl,
  xorg,
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

  env.LIBCLANG_PATH = "${llvmPackages.libclang.lib}/lib";

  nativeBuildInputs = [
    llvmPackages.bintools-unwrapped
    m4
    pkg-config
    (python3.withPackages (ps: with ps; [ webidl ]))
    writableTmpDirAsHomeHook
  ];

  buildInputs = [
    fontconfig
    libunwind
    openssl
    xorg.libX11
  ];

})
