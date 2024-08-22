{ fetchzip
, lib
, stdenvNoCC
, copyDesktopItems
, imagemagick
, makeDesktopItem
, jre
}:
let
  vPath = v: lib.elemAt (lib.splitString "-" v) 0;

  version = "2024.9-b159";

  arches = {
    aarch64-linux = "arm64";
    x86_64-linux = "x64";
  };

  arch =
    arches.${stdenvNoCC.targetPlatform.system} or (throw "Unsupported system");

  hashes = {
    arm64 = "sha256-IPgWoHLUEeMZR3kPabUeFuMLSJhhgO8BA6zTw+D3+ks=";
    x64 = "sha256-k4WptcehYrUW2eCacYdCQ1oqMXHT6zTrCHqu5eWxbp0=";
  };

  desktopItem = makeDesktopItem {
    name = "YourKit Java Profiler";
    desktopName = "YourKit Java Profiler " + version;
    type = "Application";
    exec = "yourkit-java-profiler %f";
    icon = "yourkit-java-profiler";
    categories = [ "Development" "Java" "Profiling" ];
    terminal = false;
    startupWMClass = "YourKit Java Profiler";
  };
in
stdenvNoCC.mkDerivation {
  inherit version;

  pname = "yourkit-java";

  src = fetchzip {
    url = "https://download.yourkit.com/yjp/${vPath version}/YourKit-JavaProfiler-${version}-${arch}.zip";
    hash = hashes.${arch};
  };

  nativeBuildInputs = [ copyDesktopItems imagemagick ];

  buildInputs = [ jre ];

  desktopItems = [ desktopItem ];

  installPhase = ''
    runHook preInstall

    mkdir -p $out
    cp -pr bin lib license.html license-redist.txt probes samples $out
    cp ${./forbid-desktop-item-creation} $out/bin/forbid-desktop-item-creation
    mv $out/bin/profiler.sh $out/bin/yourkit-java-profiler
    mkdir -p $out/share/icons
    convert $out/bin/profiler.ico\[0] \
            -size 256x256 \
            $out/share/icons/yourkit-java-profiler.png
    rm $out/bin/profiler.ico
    rm -rf $out/bin/{windows-*,mac,linux-{*-32,musl-*,ppc-*}}
    if [[ ${arch} = x64 ]]; then
      rm -rf $out/bin/linux-arm-64
    else
      rm -rf $out/bin/linux-x86-64
    fi
    substituteInPlace $out/bin/yourkit-java-profiler \
        --replace 'JAVA_EXE="$YD/jre64/bin/java"' JAVA_EXE=${jre}/bin/java
    # Use our desktop item, which will be purged when this package
    # gets removed
    sed -i -e "/^YD=/isource $out/bin/forbid-desktop-item-creation\\
        " \
        $out/bin/yourkit-java-profiler

    runHook postInstall
  '';

  passthru.updateScript = ./update.sh;

  meta = with lib; {
    description = "Award winning, fully featured low overhead profiler for Java EE and Java SE platforms";
    homepage = "https://www.yourkit.com";
    changelog = "https://www.yourkit.com/changes/";
    license = licenses.unfree;
    mainProgram = "yourkit-java-profiler";
    platforms = attrNames arches;
    sourceProvenance = with sourceTypes; [ binaryBytecode ];
    maintainers = with maintainers; [ herberteuler ];
  };
}
