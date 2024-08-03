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
in
maven.buildMavenPackage rec {
  pname = "vatprism";
  version = "0.3.5";
  src = fetchFromGitHub {
    owner = "marvk";
    repo = "vatprism";
    rev = "refs/tags/v${version}";
    hash = "sha256-ofEwHUCm79roHe2bawmKFw2QHhIonnlkFG5nhE6uN+g=";
  };

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

  mvnHash =
    if (stdenv.isLinux && stdenv.isAarch64) then
      "sha256-x0nFt2C7dZqMdllI1+Io9SPBY2J/dVgBTVb9T24vFFI="
    else
      "sha256-9uyNCUqnMgpiwm2kz544pWNB/SkRpASm2Dln0e4yZos=";

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
    makeWrapper ${jdk}/bin/java $out/bin/${pname} \
        --add-flags "-jar $out/vatsim-map-${version}-fat.jar" \
        --set JAVA_HOME ${jdk.home} \
        --suffix LD_LIBRARY_PATH : ${libPath}
    runHook postInstall
  '';

  meta = {
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
