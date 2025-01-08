{
  appimageTools,
  fetchurl,
  lib,
}:
let
  pname = "weektodo";
  version = "2.2.0";

  src = fetchurl {
    url = "https://github.com/manuelernestog/weektodo/releases/download/v2.2.0/WeekToDo-2.2.0.AppImage";
    hash = "sha256-5MmvmtsLFrifzPQk1zgLwKQz30XiYTU0lBe7gaAZyMA=";
  };

  appimageContents = appimageTools.extract { inherit pname version src; };

in

appimageTools.wrapType2 {
  inherit pname version src;

  extraInstallCommands = ''
    desktop_file="${appimageContents}/weektodo.desktop"
    install -m 444 -D "$desktop_file" $out/share/applications/weektodo.desktop
    sed -i 's/.*Exec.*/Exec=weektodo/' $out/share/applications/weektodo.desktop
    install -m 444 -D ${appimageContents}/weektodo.png $out/share/icons/hicolor/256x256/apps/weektodo.png
  '';

  meta = {
    description = "WeekToDo";
    longDescription = ''
       WeekToDo is a Free and Open Source Minimalist Weekly Planner and To Do list App focused on privacy. Available for Windows, Mac, Linux or online.
    '';
    homepage = "https://weektodo.me/";
    license = lib.licenses.gpl3Only;
    mainProgram = "weektodo";
    maintainers = with lib.maintainers; [ harbiinger ];
    sourceProvenance = [ lib.sourceTypes.binaryNativeCode ];
    platforms = [ "x86_64-linux" ];
  };
}
