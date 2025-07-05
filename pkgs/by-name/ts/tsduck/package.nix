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
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "tsduck";
  version = "3.40-4165";

  src = fetchFromGitHub {
    owner = "tsduck";
    repo = "tsduck";
    rev = "v${finalAttrs.version}";
    sha256 = "sha256-bFnsGoElXeStIX5KwonJuF0x7DDzhzq+3oygkUOmZE0=";
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
    "CXXFLAGS_NO_WARNINGS=-Wno-deprecated-declarations"
    "NODEKTEC=1"
    "NOGITHUB=1"
    "NOHIDES=1"
    "NOPCSC=1"
    "NOVATEK=1"
    "SYSPREFIX=/"
    "SYSROOT=${placeholder "out"}"
  ];

  # remove tests which break the sandbox
  patches = [ ./tests.patch ];
  checkTarget = "test";
  doCheck = true;
  doInstallCheck = true;

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
