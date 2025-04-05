{
  appimageTools,
  lib,
  fetchurl,
  makeWrapper,
}:
let
  pname = "unofficial-homestuck-collection";
  version = "2.5.7";
  src = fetchurl {
    url = "https://github.com/homestuck/unofficial-homestuck-collection/releases/download/${version}/The-Unofficial-Homestuck-Collection-${version}.AppImage";
    hash = "sha256-Nd+Uf3HY8MNx/8IZW5lLqsead6LMptjyVT1tTfl8K1A=";
  };
  contents = appimageTools.extract { inherit pname version src; };
in
appimageTools.wrapType2 {
  inherit pname version src;

  nativeBuildInputs = [ makeWrapper ];

  extraInstallCommands = ''
    install -d $out/share/{applications,icons}
    cp ${contents}/*.desktop -t $out/share/applications/
    cp -r ${contents}/usr/share/icons/* -t $out/share/icons/
    substituteInPlace $out/share/applications/*.desktop --replace-fail 'Exec=AppRun' "Exec=$out/bin/${pname}"
    install -d $out/lib/${pname}
    mv "$out/bin/${pname}" "$out/lib/${pname}/${pname}"
    makeWrapper "$out/lib/${pname}/${pname}" "$out/bin/${pname}" \
      --append-flags "--in-process-gpu"
  '';

  meta = {
    description = "Offline collection of Homestuck and its related works";
    homepage = "https://homestuck.github.io";
    license = lib.licenses.gpl3;
    maintainers = with lib.maintainers; [ kenshineto ];
    mainProgram = "unofficial-homestuck-collection";
    platforms = [ "x86_64-linux" ];
    sourceProvenance = [ lib.sourceTypes.binaryNativeCode ];
  };
}
