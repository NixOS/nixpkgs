{
  copyDesktopItems,
  fetchurl,
  jre,
  lib,
  makeDesktopItem,
  runtimeShell,
  stdenv,
  unzip,
}:

stdenv.mkDerivation (
  finalAttrs:
  {
    pname = "zap";
    version = "2.17.0";
    src =
      if stdenv.hostPlatform.isDarwin then
        fetchurl {
          url = "https://github.com/zaproxy/zaproxy/releases/download/v${finalAttrs.version}/ZAP_${finalAttrs.version}_Crossplatform.zip";
          hash = "sha256-lMj3Z7HC6U8Ntms65WUU1eP1pyjuG2x5jgyP4tYfv/A=";
        }
      else
        fetchurl {
          url = "https://github.com/zaproxy/zaproxy/releases/download/v${finalAttrs.version}/ZAP_${finalAttrs.version}_Linux.tar.gz";
          hash = "sha256-7+eZqqNifbaDtD8AycIQrqC3XADMjwoPBDTRK7Pd3lo=";
        };

    zapHome =
      if stdenv.hostPlatform.isDarwin then
        ''\$HOME/Library/Application\ Support/ZAP''
      else
        ''\$HOME/.ZAP'';

    desktopItems = lib.optionals stdenv.hostPlatform.isLinux [
      (makeDesktopItem {
        name = "zap";
        exec = "zap";
        icon = "zap";
        desktopName = "Zed Attack Proxy";
        categories = [
          "Development"
          "Security"
          "System"
        ];
      })
    ];

    buildInputs = [ jre ];

    nativeBuildInputs = if stdenv.hostPlatform.isDarwin then [ unzip ] else [ copyDesktopItems ];

    # From https://github.com/zaproxy/zaproxy/blob/master/zap/src/main/java/org/parosproxy/paros/Constant.java
    version_tag = "20012000";

    # Copying config and adding version tag before first use to avoid permission
    # issues if zap tries to copy config on it's own.
    installPhase = ''
      runHook preInstall

      mkdir -p $out/{bin,share}

      cp -pR . "$out/share/zap/"

      cat >> "$out/bin/zap" << EOF
      #!${runtimeShell}
      export PATH="${lib.makeBinPath [ jre ]}:\$PATH"
      export JAVA_HOME='${jre}'
      if ! [ -f "\$HOME/.ZAP/config.xml" ];then
        mkdir -p "\$HOME/.ZAP"
        head -n 2 $out/share/zap/xml/config.xml > "\$HOME/.ZAP/config.xml"
        echo "<version>${finalAttrs.version_tag}</version>" >> "\$HOME/.ZAP/config.xml"
        tail -n +3 $out/share/zap/xml/config.xml >> "\$HOME/.ZAP/config.xml"
      fi
      exec "$out/share/zap/zap.sh"  "\$@"
      EOF

      chmod u+x  "$out/bin/zap"

      runHook postInstall
    '';

    meta = {
      homepage = "https://www.zaproxy.org/";
      description = "Java application for web penetration testing";
      maintainers = with lib.maintainers; [
        mog
        rafael
      ];
      platforms = lib.platforms.linux ++ lib.platforms.darwin;
      license = lib.licenses.asl20;
      mainProgram = "zap";
    };
  }
  // lib.optionalAttrs stdenv.hostPlatform.isDarwin {
    # Remove webdriver add-ons for different platforms
    postPatch = ''
      rm plugin/webdriverlinux-*.zap plugin/webdriverwindows-*.zap
    '';
  }
)
