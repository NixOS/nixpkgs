{ stdenv, lib, makeWrapper, buildEnv }:

drv:

{ targets, paths ? [] }:

let
  env = buildEnv {
    inherit (drv) name meta;
    paths = builtins.map lib.getBin ([drv] ++ paths);
    pathsToLink = [ "/bin" "/share" "/lib/qt5" "/etc/xdg" ];
  };
in

stdenv.mkDerivation {
  inherit (drv) name meta;
  preferLocalBuild = true;

  paths = builtins.map lib.getBin ([drv] ++ paths);
  inherit drv env targets;
  passthru = { unwrapped = drv; };

  nativeBuildInputs = [ makeWrapper ];

  builder = builtins.toFile "builder.sh" ''
    . $stdenv/setup

    for t in $targets; do
        if [ -a "$drv/$t" ]; then
            makeWrapper "$drv/$t" "$out/$t" \
                --argv0 '"$0"' \
                --suffix PATH : "$env/bin" \
                --prefix XDG_CONFIG_DIRS : "$env/share" \
                --prefix XDG_DATA_DIRS : "$env/etc/xdg" \
                --set QML_IMPORT_PATH "$env/lib/qt5/imports" \
                --set QML2_IMPORT_PATH "$env/lib/qt5/qml" \
                --set QT_PLUGIN_PATH "$env/lib/qt5/plugins"
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
