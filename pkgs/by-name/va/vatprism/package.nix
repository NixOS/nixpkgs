{
  lib,
  stdenv,
  jdk,
  maven,
  makeWrapper,
  fetchFromGitHub,
  libGL,
  libxkbcommon,
  wayland,
  fontconfig,
  libX11,
  libXcursor,
  libXi,
  libXrandr,
  libXxf86vm,
  libXtst,
  copyDesktopItems,
  makeDesktopItem,
}:
let
  libPath = lib.makeLibraryPath [
    libGL
    libxkbcommon
    wayland
    libX11
    libXcursor
    libXi
    libXrandr
    libXxf86vm
    libXtst
    fontconfig
  ];
  jdkWithFX = jdk.override { enableJavaFX = true; };
in
maven.buildMavenPackage rec {
  pname = "vatprism";
  version = "0.3.6";
  src = fetchFromGitHub {
    owner = "marvk";
    repo = "vatprism";
    tag = "v${version}";
    hash = "sha256-A9HvO+tUrb/h9YZAKfTlgr+qxX7ucN/VJt4lRL94Ygg=";
  };

  postPatch =
    # mvvmFX 1.9.0-SNAPSHOT is no longer available in the repository
    ''
      substituteInPlace pom.xml \
        --replace-fail \
          '<mvvmfx.version>1.9.0-SNAPSHOT</mvvmfx.version>' \
          '<mvvmfx.version>1.8.0</mvvmfx.version>'
    '';

  nativeBuildInputs = [
    makeWrapper
    copyDesktopItems
  ];
  # https://github.com/marvk/vatprism/pull/141
  patches = [ ./0001-Fix-build-on-JDK-21.patch ];

  desktopItems = [
    (makeDesktopItem {
      name = "vatprism";
      desktopName = "VATprism";
      exec = "vatprism";
      terminal = false;
      icon = "vatprism";
    })
  ];

  mvnHash = # OpenJFX artifacts are platform dependent
    if (stdenv.hostPlatform.isLinux && stdenv.hostPlatform.isAarch64) then
      "sha256-gerjxTj8UQEVthMO3unWPEG7SPseMt5JPPureC/wUsw="
    else
      "sha256-QH14GJ8JUYuu5XWnSKPYsamFeP0o+5Sobl+a0FUOIzs=";

  installPhase = ''
    runHook preInstall
    # create the bin directory
    mkdir -p $out/bin $out/share/icons/hicolor/256x256/apps

    # copy out the JAR
    # Maven already setup the classpath to use m2 repository layout
    # with the prefix of lib/
    cp target-fat-jar/vatsim-map-${version}-fat.jar $out/
    cp src/main/resources/net/marvk/fs/vatsim/map/icon-256.png $out/share/icons/hicolor/256x256/apps/vatprism.png

    # create a wrapper that will automatically set the classpath
    # this should be the paths from the dependency derivation
    makeWrapper ${lib.getExe jdkWithFX} $out/bin/vatprism \
        --add-flags --add-exports=javafx.controls/com.sun.javafx.scene.control=ALL-UNNAMED \
        --add-flags --add-exports=javafx.graphics/com.sun.javafx.css=ALL-UNNAMED \
        --add-flags --add-exports=javafx.graphics/com.sun.javafx.scene.traversal=ALL-UNNAMED \
        --add-flags --add-exports=javafx.graphics/com.sun.javafx.scene=ALL-UNNAMED \
        --add-flags --add-exports=javafx.graphics/com.sun.javafx.tk=ALL-UNNAMED \
        --add-flags --add-opens=javafx.controls/javafx.scene.control.skin=ALL-UNNAMED \
        --add-flags "-jar $out/vatsim-map-${version}-fat.jar" \
        --set JAVA_HOME ${jdkWithFX.home} \
        --suffix LD_LIBRARY_PATH : ${libPath}
    runHook postInstall
  '';

  meta = {
    changelog = "https://github.com/marvk/vatprism/raw/${src.rev}/CHANGELOG.md";
    description = "VATSIM map and data explorer";
    longDescription = ''
      VATprism is a VATSIM Map and VATSIM Data Explorer, VATSIM being the
      Virtual Air Traffic Simulation Network. VATprism allows users to explore
      available ATC services, connected pilots, Airports, Flight and Upper
      Information Regions and more!
    '';
    homepage = "https://vatprism.org/";
    mainProgram = "vatprism";
    license = lib.licenses.agpl3Plus;
    platforms = lib.platforms.linux;
    maintainers = with lib.maintainers; [ thepuzzlemaker ];
  };
}
