{
  lib,
  stdenv,
  meson,
  ninja,
  fetchFromGitHub,
  fetchFromGitLab,
  re2c,
  gperf,
  gawk,
  pkg-config,
  boost182,
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
  gitUpdater,
}:

let
  trial-protocol-wrap = fetchFromGitHub {
    owner = "breese";
    repo = "trial.protocol";
    rev = "79149f604a49b8dfec57857ca28aaf508069b669";
    sparseCheckout = [
      "include"
    ];
    hash = "sha256-QpQ70KDcJyR67PtOowAF6w48GitMJ700B8HiEwDA5sU=";
    postFetch = ''
      rm $out/*.*
      mkdir -p $out/lib/pkgconfig
      cat > $out/lib/pkgconfig/trial-protocol.pc << EOF
        Name: trial.protocol
        Version: 0-unstable-2023-02-10
        Description:  C++ header-only library with parsers and generators for network wire protocols
        Requires:
        Libs:
        Cflags:
      EOF
    '';
  };

  boost = boost182;
in

stdenv.mkDerivation (self: {
  pname = "emilua";
  version = "0.10.1";

  src = fetchFromGitLab {
    owner = "emilua";
    repo = "emilua";
    rev = "v${self.version}";
    hash = "sha256-D6XKXik9nWQ6t6EF6dLbRGB60iFbPUM8/H8iFAz1QlE=";
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
    trial-protocol-wrap
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
    (lib.mesonBool "enable_file_io" true)
    (lib.mesonBool "enable_io_uring" true)
    (lib.mesonBool "enable_tests" true)
    (lib.mesonBool "enable_manpages" true)
    (lib.mesonOption "version_suffix" "-nixpkgs1")
  ];

  postPatch = ''
    patchShebangs src/emilua_gperf.awk --interpreter '${lib.getExe gawk} -f'
  '';

  doCheck = true;

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
      --replace @sitePackages@ "${self.passthru.sitePackages}"
  '';

  passthru = {
    updateScript = gitUpdater { rev-prefix = "v"; };
    inherit boost;
    sitePackages = "lib/emilua-${(lib.concatStringsSep "." (lib.take 2 (lib.splitVersion self.version)))}";
  };

  meta = with lib; {
    description = "Lua execution engine";
    mainProgram = "emilua";
    homepage = "https://emilua.org/";
    license = licenses.boost;
    maintainers = with maintainers; [
      manipuladordedados
      lucasew
    ];
    platforms = platforms.linux;
  };
})
