{ fetchzip
, lib
, stdenv
, copyDesktopItems
, imagemagick
, makeDesktopItem
, jre
}:
let
  vPath = v: lib.elemAt (lib.splitString "-" v) 0;

  version = "2023.9-b109";

  arches = {
    aarch64-linux = "arm64";
    x86_64-linux = "x64";
  };

  arch = arches.${stdenv.targetPlatform.system} or (throw "Unsupported system");

  hashes = {
    arm64 = "sha256-t6ly8Beu6Hrqy1W2pG9Teks+QSZxbN/KeVxKvCDuTmg=";
    x64 = "sha256-utV8x2V8MXkG0H/fJ9sScykH5OtPqxbx+RW+1ePYUog=";
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
stdenv.mkDerivation {
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
    for i in attach integrate; do
        substituteInPlace $out/bin/$i.sh \
            --replace profiler.sh yourkit-java-profiler
    done
    for i in attach integrate profiler; do
        mv $out/bin/$i.sh $out/bin/yourkit-java-$i
    done
    mkdir -p $out/share/icons
    convert $out/bin/profiler.ico\[0] \
            -size 256x256 \
            $out/share/icons/yourkit-java-profiler.png
    rm $out/bin/profiler.ico
    substituteInPlace $out/bin/yourkit-java-profiler \
        --replace 'JAVA_EXE="$YD/jre64/bin/java"' JAVA_EXE=${jre}/bin/java
    # Use our desktop item, which will be purged when this package
    # gets removed
    sed -i -e "/^YD=/isource $out/bin/forbid-desktop-item-creation\\
        " \
        $out/bin/yourkit-java-profiler

    runHook postInstall
  '';

  meta = with lib; {
    description = "Award winning, fully featured low overhead profiler for Java EE and Java SE platforms";
    homepage = "https://www.yourkit.com";
    changelog = "https://www.yourkit.com/changes/";
    license = licenses.unfree;
    mainProgram = "yourkit-java-profiler";
    platforms = platforms.linux;
    sourceProvenance = with sourceTypes; [ binaryBytecode ];
    maintainers = with maintainers; [ herberteuler ];
  };
}
