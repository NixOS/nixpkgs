{ lib
, stdenv
, fetchurl
, dpkg
, makeWrapper
, electron_25
}:

stdenv.mkDerivation rec {
  pname = "zhixi";
  version = "2.1.3.1";

  src = fetchurl {
    url = "https://cdn-resource.zhixi.com/application/soft_package/channel/80004201/21C8B557/software/2.1.3.1/jIgnVa/zhixilinux_21C8B557.deb";
    hash = "sha256-lyrtQcalSs+Z8My2AEf1K6n+Jk++4EqaDEdG33oz61M=";
  };
  sourceRoot = ".";
  unpackCmd = "${dpkg}/bin/dpkg-deb -x $src .";

  dontConfigure = true;
  dontBuild = true;

  nativeBuildInputs = [ makeWrapper ];

  installPhase = ''
    runHook preInstall

    mkdir -p $out/bin $out/share/${pname} $out/share/applications $out/share/icons/hicolor/512x512

    cp -a opt/zhiximind-desktop/{locales,resources} $out/share/${pname}
    cp -a usr/share/applications/zhiximind-desktop.desktop $out/share/applications/${pname}.desktop
    cp -a usr/share/icons/hicolor/512x512/apps $out/share/icons/hicolor/512x512

    substituteInPlace $out/share/applications/${pname}.desktop \
      --replace 'Exec=/opt/zhiximind-desktop/zhiximind-desktop' 'Exec=zhiximind-desktop'

    runHook postInstall
  '';

  postFixup = ''
    makeWrapper ${electron_25}/bin/electron $out/bin/zhiximind-desktop \
      --add-flags $out/share/${pname}/resources/app.asar \
      --prefix LD_LIBRARY_PATH : "${
        lib.makeLibraryPath [ stdenv.cc.cc ]
      }" \
      --add-flags "\''${NIXOS_OZONE_WL:+\''${WAYLAND_DISPLAY:+--ozone-platform-hint=auto --enable-features=WaylandWindowDecorations}}"
  '';

  meta = with lib; {
    homepage = "https://www.zhixi.com/";
    description = "A cross-platform mindmap and diagramming tool that is lightweight and easy to use";
    license = licenses.unfree;
    platforms = [ "x86_64-linux" ];
    maintainers = with maintainers; [ pokon548 ];
    mainProgram = "zhiximind-desktop";
    sourceProvenance = with sourceTypes; [ binaryNativeCode ];
  };
}
