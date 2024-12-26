{
  lib,
  stdenv,
  fetchurl,
  jre,
  makeDesktopItem,
  copyDesktopItems,
  runtimeShell,
}:

stdenv.mkDerivation rec {
  pname = "zap";
  version = "2.15.0";
  src = fetchurl {
    url = "https://github.com/zaproxy/zaproxy/releases/download/v${version}/ZAP_${version}_Linux.tar.gz";
    sha256 = "sha256-ZBDhlrqrRYqSBOKar7V0X8oAOipsA4byxuXAS2diH6c=";
  };

  desktopItems = [
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

  nativeBuildInputs = [ copyDesktopItems ];

  # From https://github.com/zaproxy/zaproxy/blob/master/zap/src/main/java/org/parosproxy/paros/Constant.java
  version_tag = "20012000";

  # Copying config and adding version tag before first use to avoid permission
  # issues if zap tries to copy config on it's own.
  installPhase = ''
    runHook preInstall

    mkdir -p $out/{bin,share}

    cp -pR . "$out/share/${pname}/"

    cat >> "$out/bin/${pname}" << EOF
    #!${runtimeShell}
    export PATH="${lib.makeBinPath [ jre ]}:\$PATH"
    export JAVA_HOME='${jre}'
    if ! [ -f "\$HOME/.ZAP/config.xml" ];then
      mkdir -p "\$HOME/.ZAP"
      head -n 2 $out/share/${pname}/xml/config.xml > "\$HOME/.ZAP/config.xml"
      echo "<version>${version_tag}</version>" >> "\$HOME/.ZAP/config.xml"
      tail -n +3 $out/share/${pname}/xml/config.xml >> "\$HOME/.ZAP/config.xml"
    fi
    exec "$out/share/${pname}/zap.sh"  "\$@"
    EOF

    chmod u+x  "$out/bin/${pname}"

    runHook postInstall
  '';

  meta = with lib; {
    homepage = "https://www.zaproxy.org/";
    description = "Java application for web penetration testing";
    maintainers = with maintainers; [
      mog
      rafael
    ];
    platforms = platforms.linux;
    license = licenses.asl20;
    mainProgram = "zap";
  };
}
