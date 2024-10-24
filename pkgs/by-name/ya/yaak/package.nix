{
  appimageTools,
  targetPlatform,
  fetchzip,
  stdenv,
  lib,
}:

let
  pname = "yaak";
  version = "2024.8.2";

  source =
    {
      x86_64-linux = {
        name = "${pname}_${version}_amd64";
        hash = "sha256-stZOsPFEltRNiIx7XV1ndLqh5uAW41EtZ/JD5dFd/OA=";
      };
    }
    .${targetPlatform.system} or (throw "${targetPlatform.system} is unsupported.");
in
appimageTools.wrapType2 rec {
  inherit pname version;

  archive = fetchzip {
    url = "https://releases.yaak.app/releases/${version}/${source.name}.AppImage.tar.gz";
    inherit (source) hash;
  };

  src = "${archive}/${source.name}.AppImage";

  contents = appimageTools.extract {
    inherit pname version src;
    postExtract = ''
      substituteInPlace $out/yaak-app.desktop --replace-fail 'yaak-app' '${pname}'
    '';
  };

  extraInstallCommands = ''
    install -Dm444 ${contents}/yaak-app.desktop $out/share/applications/yaak.desktop

    for size in "32x32" "128x128" "256x256@2"; do
      install -Dm444 ${contents}/usr/share/icons/hicolor/$size/apps/yaak-app.png $out/share/icons/hicolor/$size/apps/yaak.png
    done
  '';

  meta = {
    description = "Desktop API client for organizing and executing REST, GraphQL, and gRPC requests";
    homepage = "https://yaak.app/";
    license = with lib.licenses; [ mit ];
    maintainers = with lib.maintainers; [ syedahkam ];
    mainProgram = "yaak";
    platforms = [ "x86_64-linux" ];
    sourceProvenance = with lib.sourceTypes; [ binaryNativeCode ];
  };
}
