{
  fetchzip,
  lib,
  stdenvNoCC,
  copyDesktopItems,
  imagemagick,
  makeDesktopItem,
  jdk21,
  writeScript,
}:
let
  jre = jdk21;

  arches = {
    aarch64-linux = "arm64";
    x86_64-linux = "x64";
  };

  arch = arches.${stdenvNoCC.targetPlatform.system} or (throw "Unsupported system");

  hashes = {
    arm64 = "sha256-pc+Z7dMEhinNtqssTTumn3IKZEolbKlKtckMp4KkX+g=";
    x64 = "sha256-pc+Z7dMEhinNtqssTTumn3IKZEolbKlKtckMp4KkX+g=";
  };
in
stdenvNoCC.mkDerivation (finalAttrs: {
  pname = "yourkit-java";
  version = "2026.3.157";

  src = fetchzip {
    url = "https://download.yourkit.com/yjp/${finalAttrs.version}/YourKit-Java-Profiler-${finalAttrs.version}-${arch}.zip";
    hash = hashes.${arch};
  };

  nativeBuildInputs = [
    copyDesktopItems
    imagemagick
  ];

  buildInputs = [ jre ];

  desktopItems = [
    (makeDesktopItem {
      name = "YourKit Java Profiler";
      desktopName = "YourKit Java Profiler " + finalAttrs.version;
      type = "Application";
      exec = "yourkit-java-profiler %f";
      icon = "yourkit-java-profiler";
      categories = [
        "Development"
        "Java"
        "Profiling"
      ];
      terminal = false;
      startupWMClass = "YourKit Java Profiler";
    })
  ];

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

  passthru.updateScript = writeScript "update-${finalAttrs.pname}" ''
    #!/usr/bin/env nix-shell
    #!nix-shell -i bash -p coreutils curl gnugrep common-updater-scripts nix
    version="$(curl https://www.yourkit.com/java/profiler/download/ 2>/dev/null |
      grep -Eo '(Version|Build): ([a-z0-9#.-])+' |
      cut -d' ' -f2 | tr -d '\n' | tr \# .)"

    update-source-version yourkit-java "$version"

    for system in $(nix-instantiate --eval . -A yourkit-java.meta.platforms --json | jq -r '.[]'); do
      hash=$(nix-hash --to-sri --type sha256 $(nix-prefetch-url $(nix-instantiate --eval . --system "$system"-A yourkit-java.src.url --raw)))
      update-source-version yourkit-java $version $hash --system=$system --ignore-same-version
    done
  '';

  meta = {
    description = "Award winning, fully featured low overhead profiler for Java EE and Java SE platforms";
    homepage = "https://www.yourkit.com";
    changelog = "https://www.yourkit.com/changes/";
    license = lib.licenses.unfree;
    mainProgram = "yourkit-java-profiler";
    platforms = lib.attrNames arches;
    sourceProvenance = with lib.sourceTypes; [ binaryBytecode ];
    maintainers = with lib.maintainers; [ herberteuler ];
  };
})
