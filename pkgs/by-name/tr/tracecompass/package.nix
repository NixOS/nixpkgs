{
  coreutils,
  fetchurl,
  fontconfig,
  freetype,
  glib,
  gsettings-desktop-schemas,
  gtk3,
  jdk21,
  lib,
  libX11,
  libXrender,
  libXtst,
  makeDesktopItem,
  makeWrapper,
  imagemagick,
  shared-mime-info,
  stdenv,
  testers,
  webkitgtk_4_1,
  xvfb-run,
  zlib,
}:

let
  version = "11.2.0";
  buildId = "20251212-2003";
  archiveName = "trace-compass-${version}-${buildId}-linux.gtk.x86_64.tar.gz";

  desktopItem = makeDesktopItem {
    name = "tracecompass";
    exec = "tracecompass";
    icon = "tracecompass";
    comment = "Trace Compass";
    desktopName = "Trace Compass";
    categories = [
      "Development"
      "Profiling"
    ];
  };
in
stdenv.mkDerivation (finalAttrs: rec {
  pname = "tracecompass";
  inherit version;

  # Use the upstream RCP release tarball; building Trace Compass from source
  # would require a much heavier Eclipse/Tycho build pipeline.
  src = fetchurl {
    url = "https://download.eclipse.org/tracecompass/releases/${version}/rcp/${archiveName}";
    hash = "sha256-QNJAJkgpV8v94IJx/jnQQ5HhX0kuASET3ywa/nfhsEs=";
  };

  sourceRoot = "trace-compass";

  nativeBuildInputs = [
    makeWrapper
    imagemagick
  ];

  postPatch = ''
        substituteInPlace tracecompass.ini \
          --replace-fail '-vmargs' "-vm
    ${lib.getExe jdk21}
    -vmargs"
  '';

  dontBuild = true;
  dontConfigure = true;

  installPhase = ''
    runHook preInstall

    mkdir -p $out
    cp -r . $out/trace-compass

    patchelf --set-interpreter "${stdenv.cc.bintools.dynamicLinker}" $out/trace-compass/tracecompass

    mkdir -p $out/bin
    makeWrapper $out/trace-compass/tracecompass $out/bin/tracecompass \
      --prefix PATH : ${lib.makeBinPath [ jdk21 ]} \
      --set JAVA_HOME ${jdk21} \
      --prefix LD_LIBRARY_PATH : ${
        lib.makeLibraryPath [
          fontconfig
          freetype
          glib
          gtk3
          libX11
          libXrender
          libXtst
          webkitgtk_4_1
          zlib
        ]
      } \
      --prefix XDG_DATA_DIRS : "$GSETTINGS_SCHEMAS_PATH" \
      --set-default GDK_BACKEND x11 \
      --run 'if [[ " $* " != *" -configuration "* ]]; then
         set -- -configuration "$HOME/.tracecompass/${version}/configuration" "$@"
       fi'


    mkdir -p $out/share/applications
    cp ${desktopItem}/share/applications/* $out/share/applications

    for size in 16 24 32 48 64 128 256; do
      dir="$out/share/icons/hicolor/''${size}x''${size}/apps"
      mkdir -p "$dir"
      magick icon.xpm -resize "''${size}x''${size}" \
        "$dir/tracecompass.png"
    done

    runHook postInstall
  '';

  passthru = {
    updateScript = ./update.sh;
    tests.smoke = testers.runCommand {
      name = "tracecompass-smoke-test";
      nativeBuildInputs = [
        coreutils
        xvfb-run
      ];
      meta.timeout = 120;
      script = ''
        export HOME=$(mktemp -d)
        export XDG_CACHE_HOME="$HOME/.cache"
        export XDG_CONFIG_HOME="$HOME/.config"

        workspace="$HOME/workspace"
        mkdir -p "$workspace"
        logFile="$workspace/.metadata/.log"

        if timeout 30s xvfb-run -s "-screen 0 1920x1080x24" \
          ${lib.getExe finalAttrs.finalPackage} \
            --launcher.suppressErrors \
            -nosplash \
            -application org.eclipse.tracecompass.rcp.ui.application \
            -data "$workspace" \
            -configuration "$HOME/.tracecompass/${version}/configuration" \
            -vmargs -Djava.awt.headless=true
        then
          echo "Trace Compass exited before the timeout" >&2
          if [ -f "$logFile" ]; then
            cat "$logFile" >&2
          fi
          exit 1
        else
          status=$?
          if [ "$status" -ne 124 ]; then
            echo "Trace Compass failed with status $status" >&2
            if [ -f "$logFile" ]; then
              cat "$logFile" >&2
            fi
            exit $status
          fi
        fi

        touch $out
      '';
    };
  };

  meta = with lib; {
    description = "Eclipse Trace Compass trace event analyzer";
    longDescription = ''
      Trace Compass is an Eclipse application for analyzing and visualizing traces and logs.
      It helps diagnose performance issues in the Linux kernel, Android, and other systems
      by understanding what the system is doing over time.
    '';
    homepage = "https://www.eclipse.org/tracecompass/";
    changelog = "https://github.com/eclipse-tracecompass/org.eclipse.tracecompass/wiki/New_In_Trace_Compass";
    sourceProvenance = with sourceTypes; [ binaryNativeCode ];
    license = licenses.epl20;
    maintainers = with maintainers; [ lvanasse ];
    platforms = [ "x86_64-linux" ];
    mainProgram = "tracecompass";
  };
})
