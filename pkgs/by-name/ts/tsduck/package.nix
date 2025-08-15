{
  lib,
  stdenv,
  fetchFromGitHub,
  # build and doc tooling
  asciidoctor-with-extensions,
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
  editline,
  zlib,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "tsduck";
  version = "3.41-4299";

  src = fetchFromGitHub {
    owner = "tsduck";
    repo = "tsduck";
    rev = "v${finalAttrs.version}";
    sha256 = "sha256-nBPYKzb6GeBC7tTZgHLp1nAQM9SKpGhU/nHUJqT5TrY=";
  };

  nativeBuildInputs = [
    asciidoctor-with-extensions
    doxygen
    graphviz
    python3
    ruby
    qpdf
    udevCheckHook
  ];

  buildInputs = [
    curl
    editline
    glibcLocales
    jdk
    libedit
    librist
    openssl
    srt
    zlib
  ];

  enableParallelBuilding = true;

  postPatch = ''
    patchShebangs scripts
  '';

  # see CONFIG.txt in the sources
  makeFlags = [
    "CXXFLAGS_NO_WARNINGS=-Wno-deprecated-declarations"
    "NODEKTEC=1"
    "NOGITHUB=1"
    "NOHIDES=1"
    "NOPCSC=1"
    "NOVATEK=1"
    "SYSPREFIX=/"
    "SYSROOT=${placeholder "out"}"
    "RIST_DONE=1"
    "SRT_DONE=1"
  ];

  # remove tests which break the sandbox
  patches = [ ./tests.patch ];
  checkTarget = "test";
  doCheck = true;
  doInstallCheck = false;

  installTargets = [
    "install-tools"
    "install-devel"
  ];

  meta = {
    description = "MPEG Transport Stream Toolkit";
    homepage = "https://github.com/tsduck/tsduck";
    mainProgram = "tsversion";
    license = lib.licenses.bsd2;
    maintainers = with lib.maintainers; [ siriobalmelli ];
    platforms = lib.platforms.all;
  };
})
