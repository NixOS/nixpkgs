{ stdenv
, lib
, fetchzip
, autoPatchelfHook

, libusb1
, qt5
, libGL
}:
stdenv.mkDerivation {
  pname = "xppen";
  version = "3.4.9";

  src = fetchzip {
    extension = "tar.gz";
    url = "https://www.xp-pen.com/download/file.html?id=1936&pid=990&ext=gz";
    hash = "sha256-A/dv6DpelH0NHjlGj32tKv37S+9q3F8cYByiYlMuqLg=";
  };

  nativeBuildInputs = [ autoPatchelfHook qt5.wrapQtAppsHook ];

  buildInputs = [ qt5.full libusb1 libGL ];

  dontConfigure = true;
  dontBuild = true;
  dontCheck = true;

  installPhase = ''
    runHook preInstall
    mkdir -p $out/bin $out/share/doc $out/usr/lib/pentablet

    cp -r App/usr/share/. $out/share
    cp -r App/usr/lib/pentablet/doc/. $out/share/doc
    cp -r App/lib $out/lib

    cp -r App/usr/lib/pentablet/. $out/bin/
    cp -r $out/bin/conf $out/usr/lib/pentablet

    rm $out/bin/PenTablet.sh
    rm -r $out/bin/conf
    rm -r $out/bin/doc
    rm -r $out/bin/lib
    rm -r $out/bin/platforms
    runHook postInstall
  '';

  postInstall = ''
    sed -i 's#/usr/lib/pentablet#/var/lib/pentablet#g' $out/bin/PenTablet

    substituteInPlace $out/share/applications/xppentablet.desktop \
      --replace-fail "/usr/lib/pentablet/PenTablet.sh" "PenTablet" \
      --replace "/usr/share/icons/hicolor/256x256/apps/xppentablet.png" "xppentablet"
  '';

  meta = with lib; {
    description = "XPPen driver";
    homepage = "https://www.xp-pen.com/";
    downloadPage = "https://www.xp-pen.com/download/";
    license = licenses.unfree;
    maintainers = with maintainers; [ nasrally ];
    mainProgram = "PenTablet";
    platforms = platforms.linux;
  };
}
