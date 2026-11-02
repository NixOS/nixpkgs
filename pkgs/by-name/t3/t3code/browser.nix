{
  lib,
  alsa-lib,
  at-spi2-atk,
  autoPatchelfHook,
  dbus,
  expat,
  fetchurl,
  glib,
  libgbm,
  libx11,
  libxcb,
  libxcomposite,
  libxdamage,
  libxext,
  libxfixes,
  libxkbcommon,
  libxrandr,
  nspr,
  nss,
  stdenv,
  systemdLibs,
  testers,
  unzip,
}:

let
  # Must match VERSION and ARCHIVES in apps/server/src/preview/PreviewBrowser.ts;
  # update it with each t3code bump.
  archives = {
    x86_64-linux = {
      platform = "linux64";
      sha256 = "a313da592261ff1e342c1e507d315f25b1809006c0508f77ce86151d464d4ccb";
    };
    aarch64-linux = {
      platform = "linux-arm64";
      sha256 = "dca11213d2e0b1db52141edd9f92ec423fd52ca25715846790d84fa1d5d16e8a";
    };
  };
  archive =
    archives.${stdenv.hostPlatform.system}
      or (throw "chrome-headless-shell: unsupported system ${stdenv.hostPlatform.system}");
in
stdenv.mkDerivation (finalAttrs: {
  pname = "t3code-browser";
  version = "156.0.8078.70";
  strictDeps = true;

  src = fetchurl {
    url = "https://storage.googleapis.com/chrome-for-testing-public/${finalAttrs.version}/${archive.platform}/chrome-headless-shell-${archive.platform}.zip";
    inherit (archive) sha256;
  };

  nativeBuildInputs = [
    unzip
    autoPatchelfHook
  ];

  buildInputs = [
    alsa-lib
    at-spi2-atk
    dbus
    expat
    glib
    libgbm
    libx11
    libxcb
    libxcomposite
    libxdamage
    libxext
    libxfixes
    libxkbcommon
    libxrandr
    nspr
    nss
    systemdLibs
  ];

  dontBuild = true;

  installPhase = ''
    runHook preInstall
    mkdir -p "$out/libexec/t3code-browser" "$out/bin"
    cp -R . "$out/libexec/t3code-browser"
    ln -s "$out/libexec/t3code-browser/chrome-headless-shell" "$out/bin/chrome-headless-shell"
    runHook postInstall
  '';

  passthru = {
    inherit (archive) platform;
    inherit archives;
    tests.render = testers.runNixOSTest {
      name = "t3code-browser";
      nodes.machine = {
        environment.systemPackages = [ finalAttrs.finalPackage ];
        users.users.browser.isNormalUser = true;
      };
      testScript = ''
        machine.start()
        machine.wait_for_unit("multi-user.target")
        output = machine.succeed(
            "runuser -u browser -- timeout 30s chrome-headless-shell "
            "--disable-gpu --screenshot=/tmp/browser.png --dump-dom "
            "'data:text/html,<h1>t3code-browser-ok</h1>'"
        )
        assert "t3code-browser-ok" in output
        machine.succeed("test -s /tmp/browser.png")
      '';
    };
  };

  meta = {
    description = "Chrome for Testing headless shell pinned by T3 Code";
    homepage = "https://googlechromelabs.github.io/chrome-for-testing/";
    license = lib.licenses.bsd3;
    maintainers = [ lib.maintainers.otavio ];
    mainProgram = "chrome-headless-shell";
    platforms = lib.attrNames archives;
    sourceProvenance = [ lib.sourceTypes.binaryNativeCode ];
  };
})
