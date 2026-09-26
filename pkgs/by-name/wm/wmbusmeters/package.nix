{
  lib,
  stdenv,
  fetchFromGitHub,
  rtl-sdr,
  rtl_wmbus,
  rtl_433,
  libxml2,
  pkg-config,
  netcat,
  jq,
  unixtools,
  versionCheckHook,
  nix-update-script,
  installShellFiles,
}:

stdenv.mkDerivation (finalAttrs: {
  strictDeps = true;
  __structuredAttrs = true;

  pname = "wmbusmeters";
  version = "3.0.0";

  src = fetchFromGitHub {
    owner = "wmbusmeters";
    repo = "wmbusmeters";
    tag = "${finalAttrs.version}";
    hash = "sha256-kguAEWFRzdjsqgiXC7wrAkkR8qvE2ksOOhT7VrDzqc4=";

    # need to fetch revision from git
    leaveDotGit = true;
    postFetch = ''
      # avoid having the whole .git-folder
      substituteInPlace $out/Makefile --replace-fail "COMMIT_HASH?=\$(shell \$(SUPRE) git log --pretty=format:'%H' -n 1 \$(SUPOST))" "COMMIT_HASH:=$(git -C $out log --pretty=format:'%H' -n 1)"

      rm -rf $out/.git
    '';
  };

  buildInputs = [
    rtl-sdr
    rtl_wmbus
    rtl_433
    libxml2
  ];

  nativeBuildInputs = [
    pkg-config
    installShellFiles
    libxml2.dev # for xml2-config
  ];

  nativeCheckInputs = [
    netcat
    jq
    unixtools.xxd
  ];

  # avoid reading the version from git to avoid fetching all tags
  makeFlags = [
    "TAG=${finalAttrs.version}"
    "BRANCH="
    "CHANGES="
  ];

  postPatch = ''
    # avoid building of xmq and skip these tests
    substituteInPlace Makefile --replace-fail "test: build/xmq" "test:"

    patchShebangs \
      scripts/{generate_authors,generate_short_manual}.sh \
      test.sh tests/*.sh
  '';

  # avoid install.sh
  installPhase = ''
    mkdir -p $out/bin
    cp build/wmbusmeters $out/bin
    cp build/wmbusmetersd $out/bin

    # wmbusmeters will look in its own directory for these executables
    ln -s ${rtl-sdr}/bin/rtl_sdr $out/bin
    ln -s ${rtl_wmbus}/bin/rtl_wmbus $out/bin
    ln -s ${rtl_433}/bin/rtl_433 $out/bin

    installManPage wmbusmeters.1
  '';

  doCheck = true;
  checkTarget = "test";

  nativeInstallCheckInputs = [ versionCheckHook ];
  doInstallCheck = true;

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Read the wired or wireless mbus protocol to acquire utility meter readings";
    downloadPage = "https://github.com/wmbusmeters/wmbusmeters";
    homepage = "https://wmbusmeters.org/";
    license = lib.licenses.gpl3Only;
    mainProgram = "wmbusmeters";
    maintainers = with lib.maintainers; [ prauscher ];
    platforms = with lib.platforms; linux;
  };
})
