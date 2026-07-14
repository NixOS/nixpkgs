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
  version = "0.12.1";

  src = fetchFromGitLab {
    owner = "emilua";
    repo = "emilua";
    tag = "v${finalAttrs.version}";
    hash = "sha256-h/uC5yAj64A5cVQN6XPVlFg+mDFdugwWblp6qNoU824=";
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

  patches = [
    # https://gitlab.com/emilua/emilua/-/commit/9f3964f22b2289c98b64a1af729712a862459aeb
    # The above commit added a fallback allocator that just calls `realloc` from
    # libc, which is fine on x86 because Linux userspace pointers are 47 bits on
    # x86-64 and that aligns perfectly with LuaJIT's NaN-tagging representation:
    # https://github.com/LuaJIT/LuaJIT/issues/49
    # But on ARM64, Linux userspace pointers are 48 bits, so libc does not
    # provide an allocator that can be safely used for LuaJIT. To fix that, we
    # delete the libc-based allocator and instead use LuaJIT's own default
    # allocator as the fallback, which is what Emilua did before the regression.
    ./use-luajit-default-allocator.patch
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
