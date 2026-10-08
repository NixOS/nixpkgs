{
  lib,
  stdenv,
  fetchFromGitHub,
  nix-update-script,
  testers,
  # build and doc tooling
  asciidoctor,
  doxygen,
  graphviz,
  python3,
  ruby,
  qpdf,
  udevCheckHook,
  # build deps
  curl,
  glibcLocales,
  jdk,
  libedit,
  librist,
  openssl,
  srt,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "tsduck";
  version = "3.44-4676";

  src = fetchFromGitHub {
    owner = "tsduck";
    repo = "tsduck";
    tag = "v${finalAttrs.version}";
    hash = "sha256-Wiy59XEvyz9nDCZ+bCuBLVBH4ETFUnMArWi32jtmSKI=";
  };

  nativeBuildInputs = [
    asciidoctor
    doxygen
    graphviz
    python3
    ruby
    qpdf
    udevCheckHook
  ];

  buildInputs = [
    curl
    glibcLocales
    jdk
    libedit
    librist
    openssl
    srt
  ];

  enableParallelBuilding = true;

  postPatch = ''
    patchShebangs scripts
  '';

  # see CONFIG.txt in the sources
  makeFlags = [
    "NODEKTEC=1"
    "NOGITHUB=1"
    "NOHIDES=1"
    "NOPCSC=1"
    "NOVATEK=1"
    "SYSPREFIX=/"
    "SYSROOT=${placeholder "out"}"
  ];

  patches = [
    # remove -Werror: we package release tags, not debug builds;
    # new compiler warnings should not break a released version
    ./no-werror.patch
    # disable unit tests that cannot run in the nix sandbox (no network,
    # no $HOME). Only the TSUNIT_DEFINE_TEST stanzas are removed; the
    # matching TSUNIT_DECLARE_TEST lines remain as harmless declarations.
    ./tests-sandbox.patch
    # fall back when Linux builders use scheduler policies rejected by pthreads
    ./sched-policy-fallback.patch
  ];
  checkTarget = "test";
  doCheck = true;
  doInstallCheck = true;

  installTargets = [
    "install-tools"
    "install-devel"
  ];

  passthru = {
    tests.version = testers.testVersion {
      package = finalAttrs.finalPackage;
      command = "tsversion";
    };
    updateScript = nix-update-script {
      extraArgs = [
        "--version-regex"
        "^v(.+)$"
      ];
    };
  };

  meta = {
    description = "MPEG Transport Stream Toolkit";
    homepage = "https://github.com/tsduck/tsduck";
    mainProgram = "tsversion";
    license = lib.licenses.bsd2;
    maintainers = with lib.maintainers; [ siriobalmelli ];
    platforms = lib.platforms.all;
  };
})
