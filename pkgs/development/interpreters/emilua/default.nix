{
  lib,
  stdenv,
  meson,
  ninja,
  fetchFromGitLab,
  re2c,
  gperf,
  gawk,
  pkg-config,
  boost,
  fmt,
  luajit_openresty,
  ncurses,
  serd,
  sord,
  libcap,
  liburing,
  openssl,
  cereal,
  cmake,
  asciidoctor,
  makeWrapper,
  versionCheckHook,
  gitUpdater,
  enableIoUring ? false,
  emilua, # this package
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "emilua";
  version = "0.11.6";

  src = fetchFromGitLab {
    owner = "emilua";
    repo = "emilua";
    tag = "v${finalAttrs.version}";
    hash = "sha256-r/WfRAr8AgnZGHxzcZVLg5MHDwcOTMWqOv/Qu/75Y1c=";
  };

  propagatedBuildInputs = [
    luajit_openresty
    boost
    fmt
    ncurses
    serd
    sord
    libcap
    liburing
    openssl
    cereal
  ];

  nativeBuildInputs = [
    re2c
    gperf
    gawk
    pkg-config
    asciidoctor
    meson
    cmake
    ninja
    makeWrapper
  ];

  dontUseCmakeConfigure = true;

  mesonFlags = [
    (lib.mesonBool "enable_io_uring" enableIoUring)
    (lib.mesonBool "enable_file_io" enableIoUring)
    (lib.mesonBool "enable_tests" true)
    (lib.mesonBool "enable_manpages" true)
    (lib.mesonOption "version_suffix" "-nixpkgs1")
  ];

  postPatch = ''
    patchShebangs src/emilua_gperf.awk --interpreter '${lib.getExe gawk} -f'
  '';

  # io_uring is not allowed in Nix sandbox, that breaks the tests
  doCheck = !enableIoUring;

  mesonCheckFlags = [
    # Skipped test: libpsx
    # Known issue with no-new-privs disabled in the Nix build environment.
    "--no-suite"
    "libpsx"
  ];

  postInstall = ''
    mkdir -p $out/nix-support
    cp ${./setup-hook.sh} $out/nix-support/setup-hook
    substituteInPlace $out/nix-support/setup-hook \
      --replace-fail @sitePackages@ "${finalAttrs.passthru.sitePackages}"
  '';

  nativeInstallCheckInputs = [
    versionCheckHook
  ];
  versionCheckProgramArg = "--version";
  doInstallCheck = true;

  passthru = {
    updateScript = gitUpdater { rev-prefix = "v"; };
    inherit boost;
    sitePackages = "lib/emilua-${(lib.concatStringsSep "." (lib.take 2 (lib.splitVersion finalAttrs.version)))}";
    tests.with-io-uring = emilua.override { enableIoUring = true; };
  };

  meta = {
    description = "Lua execution engine";
    mainProgram = "emilua";
    homepage = "https://emilua.org/";
    license = lib.licenses.boost;
    maintainers = with lib.maintainers; [
      manipuladordedados
      lucasew
    ];
    platforms = lib.platforms.linux;
  };
})
