{
  lib,
  stdenv,
  fetchzip,
  makeWrapper,
  unzip,
  jre,
  wrapGAppsHook3,
}:

stdenv.mkDerivation rec {
  pname = "yEd";
  version = "3.24";

  src = fetchzip {
    url = "https://www.yworks.com/resources/yed/demo/${pname}-${version}.zip";
    sha256 = "sha256-4aotsOippuKUucweWERtqm/5pz2gwW1Sue48KPisQ0I=";
  };

  nativeBuildInputs = [
    makeWrapper
    unzip
    wrapGAppsHook3
  ];
  # For wrapGAppsHook3 setup hook
  buildInputs = [ (jre.gtk3 or null) ];

  dontConfigure = true;
  dontBuild = true;
  dontInstall = true;

  preFixup = ''
    mkdir -p $out/yed
    cp -r * $out/yed
    mkdir -p $out/bin

    makeWrapperArgs+=("''${gappsWrapperArgs[@]}")
    makeWrapper ${jre}/bin/java $out/bin/yed \
      ''${makeWrapperArgs[@]} \
      --add-flags "-jar $out/yed/yed.jar --"
  '';
  dontWrapGApps = true;

  meta = with lib; {
    license = licenses.unfree;
    sourceProvenance = with sourceTypes; [ binaryBytecode ];
    homepage = "https://www.yworks.com/products/yed";
    description = "Powerful desktop application that can be used to quickly and effectively generate high-quality diagrams";
    platforms = jre.meta.platforms;
    maintainers = with maintainers; [ abbradar ];
    mainProgram = "yed";
  };
}
