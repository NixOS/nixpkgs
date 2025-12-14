{
  lib,
  stdenv,
  fetchgit,
  rtl-sdr,
  libxml2,
  git,
  pkg-config,
  netcat,
  jq,
  unixtools,
  versionCheckHook,
  nix-update-script,
}:

stdenv.mkDerivation rec {
  pname = "wmbusmeters";
  version = "1.19.0";

  # fetchFromGitHub does not support leaveDotGit
  src = fetchgit {
    url = "https://github.com/wmbusmeters/wmbusmeters";
    tag = version;
    hash = "sha256-JMDwK+4pEMpl8DGitsytLooxwz82KFO0kbduRtToAV8=";

    # need to fetch revision from git
    leaveDotGit = true;
  };

  buildInputs = [
    rtl-sdr
    libxml2
  ];

  nativeBuildInputs = [
    git
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
    cp build/wmbusmetersd $out/bin

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

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Read the wired or wireless mbus protocol to acquire utility meter readings.";
    downloadPage = "https://github.com/wmbusmeters/wmbusmeters";
    homepage = "https://wmbusmeters.org/";
    license = lib.licenses.gpl3Only;
    mainProgram = "wmbusmeters";
    platforms = with lib.platforms; linux ++ darwin;
  };
}
