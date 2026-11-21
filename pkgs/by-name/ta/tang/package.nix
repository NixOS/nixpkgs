{
  asciidoc,
  fetchFromGitHub,
  gitUpdater,
  jansson,
  jose,
  lib,
  llhttp,
  makeWrapper,
  meson,
  ninja,
  nixosTests,
  pkg-config,
  stdenv,
  systemdLibs,
  tang,
  testers,
  versionCheckHook,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "tang";
  version = "16";

  src = fetchFromGitHub {
    owner = "latchset";
    repo = "tang";
    tag = "v${finalAttrs.version}";
    hash = "sha256-YpRoJ6G7Dj7arHwBrfCkroRd2nz/0ItzFmZPFQKjiYo=";
  };

  patches = [ ./meson-no-dirs-on-native.patch ];

  nativeBuildInputs = [
    asciidoc
    makeWrapper
    meson
    ninja
    pkg-config
  ];

  buildInputs = [
    jansson
    jose
    llhttp
    systemdLibs
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

  versionCheckProgram = "${placeholder "out"}/libexec/tangd";
  nativeInstallCheckInputs = [ versionCheckHook ];
  doInstallCheck = true;

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
    platforms = lib.platforms.linux;
  };
})
