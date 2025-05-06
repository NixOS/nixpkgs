{
  fetchFromGitHub,
  gnupg,
  gpgme,
  isLuaJIT,
  lib,
  libgit2,
  libgpg-error,
  lua,
  nix,
  openssl,
  pkg-config,
  rustPlatform,
  stdenv,
}:
let
  luaMajorMinor = lib.take 2 (lib.splitVersion lua.version);
  luaVersionDir = if isLuaJIT then "jit" else lib.concatStringsSep "." luaMajorMinor;
  luaFeature = if isLuaJIT then "luajit" else "lua${lib.concatStringsSep "" luaMajorMinor}";
in
rustPlatform.buildRustPackage rec {
  pname = "lux-lua";

  version = "0.1.0";

  src = fetchFromGitHub {
    owner = "nvim-neorocks";
    repo = "lux";
    # NOTE: Lux's tags represent the lux-cli version, which may differ from the lux-lua version
    tag = "v0.3.14";
    hash = "sha256-gkUj3eeN0GnHM5sN4SKM/nHeBKe9ifrkg8TZRvA7FlM=";
  };

  buildAndTestSubdir = "lux-lua";
  buildNoDefaultFeatures = true;
  buildFeatures = [ luaFeature ];

  useFetchCargoVendor = true;
  cargoHash = "sha256-2bFVF4X4OpWwbxAjTr0orCLQNHKSO/koyeTXtD6d76M=";

  nativeBuildInputs = [
    pkg-config
  ];

  buildInputs = [
    gnupg
    gpgme
    libgit2
    libgpg-error
    lua
    openssl
  ];

  # lux-lua checks are broken right now (https://github.com/nvim-neorocks/lux/pull/616)
  doCheck = false;
  useNextest = true;
  nativeCheckInputs = [
    lua
    nix
  ];

  env = {
    LIBGIT2_NO_VENDOR = 1;
    LIBSSH2_SYS_USE_PKG_CONFIG = 1;
    LUX_SKIP_IMPURE_TESTS = 1; # Disable impure unit tests
  };

  installPhase =
    let
      libExt = stdenv.hostPlatform.extensions.sharedLibrary;
    in
    ''
      mkdir -p $out/${luaVersionDir}
      ls target/release
      install -T -v target/*/release/liblux_lua${libExt} $out/${luaVersionDir}/lux.so
    '';

  cargoTestFlags = "--lib"; # Disable impure integration tests

  meta = {
    description = "Lua API for the Lux package manager";
    homepage = "https://nvim-neorocks.github.io/";
    changelog = "https://github.com/nvim-neorocks/lux/blob/${src.tag}/CHANGELOG.md";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [
      mrcjkb
    ];
    platforms = lib.platforms.all;
  };
}
