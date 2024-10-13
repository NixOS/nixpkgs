{
  lib,
  stdenv,
  fetchurl,
  autoPatchelfHook,
  alsa-lib,
  libX11,
  pcsclite,
  testers,
}:

stdenv.mkDerivation (
  finalAttrs:
  let
    version = "4.17.0";
    buildNum = "3543";
  in
  {
    pname = "tlclient";
    version = "${version}-${buildNum}";

    src = fetchurl {
      url = "https://www.cendio.com/downloads/clients/tl-${finalAttrs.version}-client-linux-dynamic-x86_64.tar.gz";
      hash = "sha256-7pl97xGNFwSDpWMpBvkz/bfMsWquVsJVGB+feWJvRQY=";
    };

    nativeBuildInputs = [
      autoPatchelfHook
    ];

    buildInputs = [
      alsa-lib
      libX11
      pcsclite
    ];

    dontConfigure = true;
    dontBuild = true;

    installPhase = ''
      runHook preInstall

      mkdir -p "$out"
      cp -R lib "$out/"
      cp -R lib/tlclient/share "$out/"

      install -Dm644 "lib/tlclient/EULA.txt" "$out/share/licenses/tlclient/EULA.txt"
      install -m644 "lib/tlclient/open_source_licenses.txt" "$out/share/licenses/tlclient/open_source_licenses.txt"
      substituteInPlace "$out/share/applications/thinlinc-client.desktop" \
        --replace-fail "/opt/thinlinc/bin/" ""

      install -Dm644 "etc/tlclient.conf" "$out/etc/tlclient.conf"
      install -Dm755 bin/tlclient* -t "$out/bin"
      install -Dm644 "lib/tlclient/thinlinc_128.png" "$out/share/icons/hicolor/128x128/apps/thinlinc-client.png"

      runHook postInstall
    '';

    passthru.tests.version = testers.testVersion {
      package = finalAttrs.finalPackage;
      version = "${version} build ${buildNum}";
    };

    meta = {
      description = "Linux remote desktop client built on open source technology";
      license = {
        fullName = "Cendio End User License Agreement 3.2";
        url = "https://www.cendio.com/thinlinc/docs/legal/eula";
        free = false;
      };
      homepage = "https://www.cendio.com/";
      changelog = "https://www.cendio.com/thinlinc/docs/relnotes/${version}/";
      maintainers = with lib.maintainers; [ felixalbrigtsen ];
      platforms = with lib.platforms; linux ++ darwin ++ windows;
      broken = !(stdenv.hostPlatform.isLinux && stdenv.hostPlatform.isx86_64);
      mainProgram = "tlclient";
    };
  }
)
