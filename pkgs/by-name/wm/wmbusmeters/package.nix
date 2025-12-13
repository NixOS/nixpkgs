{
  lib,
  stdenv,
  fetchFromGitHub,
  rtl-sdr,
  libxml2,
  pkg-config,
  netcat,
  jq,
  unixtools,
  versionCheckHook,
}:

stdenv.mkDerivation rec {
  pname = "wmbusmeters";
  version = "1.19.0";

  src = fetchFromGitHub {
    owner = "wmbusmeters";
    repo = "wmbusmeters";

    # need to store rev as COMMIT_HASH later
    rev = "41dc2d47fda72e78964b9283c99a0c98492360ba";
    hash = "sha256-Y/xHw++llHw3iIImXllJg7QqU0Ngj0MLJyyqE1dBNjA=";
  };

  buildInputs = [
    rtl-sdr
    libxml2
  ];

  nativeBuildInputs = [
    pkg-config
    libxml2.dev
  ];

  checkInputs = [
    netcat
    jq
    unixtools.xxd
  ];

  # avoid reading the version from git to avoid fetching all tags
  makeFlags = [
    "COMMIT_HASH=${src.rev}"
    "TAG=${version}"
    "BRANCH="
    "CHANGES="
  ];

  postPatch = ''
    # See https://github.com/wmbusmeters/wmbusmeters/pull/1666
    substituteInPlace Makefile --replace-fail "/usr/include/libxml2" "${libxml2.dev}/include/libxml2"

    patchShebangs scripts/generate_authors.sh
    patchShebangs test.sh tests/*.sh
  '';

  # avoid install.sh
  installPhase = ''
    mkdir -p $out/bin
    cp build/wmbusmeters $out/bin

    mkdir -p $out/man/man1
    gzip -v9 -n -c wmbusmeters.1 > $out/man/man1/wmbusmeters.1.gz
  '';

  doCheck = true;
  checkTarget = "test";
  preCheck = ''
    # avoid building of xmq and skip these tests
    substituteInPlace Makefile --replace-fail "test: build/xmq" "test:"
  '';

  nativeInstallCheckInputs = [ versionCheckHook ];
  doInstallCheck = true;

  meta = {
    description = "Read the wired or wireless mbus protocol to acquire utility meter readings.";
    downloadPage = "https://github.com/wmbusmeters/wmbusmeters";
    homepage = "https://wmbusmeters.org/";
    license = lib.licenses.gpl3Only;
    mainProgram = "wmbusmeters";
    platforms = with lib.platforms; linux ++ darwin;
  };
}
