{ stdenv, lib, makeWrapper }:

drv:

{ targets, paths ? [] }:

stdenv.mkDerivation {
  inherit (drv) name meta;

  paths = builtins.map lib.getBin ([drv] ++ paths);
  inherit drv targets;
  passthru = { unwrapped = drv; };

  nativeBuildInputs = [ makeWrapper ];

  unpackPhase = "true";
  configurePhase = "runHook preConfigure; runHook postConfigure";
  buildPhase = "true";

  installPhase = ''
    propagated=
    for p in $drv $paths; do
        findInputs $p propagated propagated-user-env-packages
    done

    wrap_PATH="$out/bin"
    wrap_XDG_DATA_DIRS=
    wrap_XDG_CONFIG_DIRS=
    wrap_QML_IMPORT_PATH=
    wrap_QML2_IMPORT_PATH=
    wrap_QT_PLUGIN_PATH=
    for p in $propagated; do
        addToSearchPath wrap_PATH "$p/bin"
        addToSearchPath wrap_XDG_DATA_DIRS "$p/share"
        addToSearchPath wrap_XDG_CONFIG_DIRS "$p/etc/xdg"
        addToSearchPath wrap_QML_IMPORT_PATH "$p/lib/qt5/imports"
        addToSearchPath wrap_QML2_IMPORT_PATH "$p/lib/qt5/qml"
        addToSearchPath wrap_QT_PLUGIN_PATH "$p/lib/qt5/plugins"
    done

    for t in $targets; do
        if [ -a "$drv/$t" ]; then
            makeWrapper "$drv/$t" "$out/$t" \
                --argv0 '"$0"' \
                --suffix PATH : "$wrap_PATH" \
                --prefix XDG_CONFIG_DIRS : "$wrap_XDG_CONFIG_DIRS" \
                --prefix XDG_DATA_DIRS : "$wrap_XDG_DATA_DIRS" \
                --set QML_IMPORT_PATH "$wrap_QML_IMPORT_PATH" \
                --set QML2_IMPORT_PATH "$wrap_QML2_IMPORT_PATH" \
                --set QT_PLUGIN_PATH "$wrap_QT_PLUGIN_PATH"
        else
            echo "no such file or directory: $drv/$t"
            exit 1
        fi
    done

    if [ -a "$drv/share" ]; then
        ln -s "$drv/share" "$out"
    fi

    if [ -a "$drv/nix-support/propagated-user-env-packages" ]; then
        mkdir -p "$out/nix-support"
        ln -s "$drv/nix-support/propagated-user-env-packages" "$out/nix-support/"
    fi
  '';
}
