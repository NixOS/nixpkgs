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
  perl,
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

  cargoHash = lux-cli.cargoHash;

  nativeBuildInputs = [
    perl
    pkg-config
  ];

  buildInputs = [
    gnupg
    gpgme
    libgit2
    libgpg-error
    openssl
  ];

  propagatedBuildInputs = [
    lua
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

  buildPhase = ''
    runHook preBuild
    cargo xtask-${luaFeature} dist
    mkdir -p $out
    runHook postBuild
  '';

  installPhase = ''
    runHook preInstall
    cp -r target/dist/share $out
    cp -r target/dist/lib $out
    mkdir -p $out/lib/lua
    ln -s $out/share/lux-lua/${luaVersionDir} $out/lib/lua/${luaVersionDir}
    runHook postInstall
  '';

  cargoTestFlags = "--lib"; # Disable impure integration tests

  meta = {
    description = "Lua API for the Lux package manager";
    homepage = "https://lux.lumen-labs.org/";
    changelog = "https://github.com/lumen-oss/lux/blob/${src.tag}/CHANGELOG.md";
    license = lib.licenses.lgpl3Plus;
    maintainers = with lib.maintainers; [
      mrcjkb
    ];
    platforms = lib.platforms.all;
  };
}
