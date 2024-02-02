{ stdenv
, lib
, fetchzip
, libusb1
, autoPatchelfHook
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

  nativeBuildInputs = [ autoPatchelfHook ];

  buildInputs = [ qt5.full libusb1 libGL ];

  dontConfigure = true;
  dontBuild = true;
  dontCheck = true;

  installPhase = ''
    runHook preInstall
    mkdir -p $out/bin $out/share
    cp -r App/usr/lib/pentablet/. $out/bin
    rm $out/bin/PenTablet.sh
    cp -r App/usr/share/. $out/share
    rm -r $out/bin/lib
    cp -r App/lib $out/lib
    runHook postInstall
  '';

  postInstall = ''
    substituteInPlace $out/share/applications/xppentablet.desktop \
      --replace "/usr/lib/pentablet/PenTablet.sh" "PenTablet" \
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
