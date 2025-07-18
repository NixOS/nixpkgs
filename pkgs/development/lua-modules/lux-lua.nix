{
  gnupg,
  gpgme,
  isLuaJIT,
  lib,
  libgit2,
  libgpg-error,
  lua,
  lux-cli,
  nix,
  openssl,
  pkg-config,
  rustPlatform,
}:
let
  luaMajorMinor = lib.take 2 (lib.splitVersion lua.version);
  luaVersionDir = if isLuaJIT then "jit" else lib.concatStringsSep "." luaMajorMinor;
  luaFeature = if isLuaJIT then "luajit" else "lua${lib.concatStringsSep "" luaMajorMinor}";
in
rustPlatform.buildRustPackage rec {
  pname = "lux-lua";

  version = lux-cli.version;

  src = lux-cli.src;

  buildAndTestSubdir = "lux-lua";
  buildNoDefaultFeatures = true;
  buildFeatures = [ luaFeature ];

  useFetchCargoVendor = true;
  cargoHash = lux-cli.cargoHash;

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

  doCheck = false; # lux-lua tests are broken in nixpkgs
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

  postBuild = ''
    cargo xtask-${luaFeature} dist
  '';

  installPhase = ''
    runHook preInstall
    install -D -v target/dist/${luaVersionDir}/* -t $out/${luaVersionDir}
    install -D -v target/dist/lib/pkgconfig/* -t $out/lib/pkgconfig
    runHook postInstall
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
