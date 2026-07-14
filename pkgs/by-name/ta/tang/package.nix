{
  lib,
  stdenv,
  fetchFromGitHub,
  pkg-config,
  asciidoc-full,
  jansson,
  jose,
  http-parser,
  systemd,
  meson,
  ninja,
  makeWrapper,
  testers,
  tang,
  gitUpdater,
  nixosTests,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "tang";
  version = "15";

  src = fetchFromGitHub {
    owner = "latchset";
    repo = "tang";
    tag = "v${finalAttrs.version}";
    hash = "sha256-nlC2hdNzQZrfirjS2gX4oFp2OD1OdxmLsN03hfxD3ug=";
  };

  nativeBuildInputs = [
    asciidoc-full
    meson
    ninja
    pkg-config
    makeWrapper
  ];

  buildInputs = [
    jansson
    jose
    http-parser
    systemd
  ];

  outputs = [
    "out"
    "man"
  ];

  postFixup = ''
    wrapProgram $out/bin/tang-show-keys --prefix PATH ":" ${lib.makeBinPath [ jose ]}
    wrapProgram $out/libexec/tangd-keygen --prefix PATH ":" ${lib.makeBinPath [ jose ]}
    wrapProgram $out/libexec/tangd-rotate-keys --prefix PATH ":" ${lib.makeBinPath [ jose ]}
  '';

  passthru = {
    tests = {
      inherit (nixosTests) tang;
      version = testers.testVersion {
        package = tang;
        command = "${tang}/libexec/tangd --version";
        version = "tangd ${finalAttrs.version}";
      };
    };
    updateScript = gitUpdater { };
  };

  meta = {
    description = "Server for binding data to network presence";
    homepage = "https://github.com/latchset/tang";
    changelog = "https://github.com/latchset/tang/releases/tag/v${finalAttrs.version}";
    maintainers = with lib.maintainers; [ fpletz ];
    license = lib.licenses.gpl3Plus;
    mainProgram = "tangd";
  };
})
