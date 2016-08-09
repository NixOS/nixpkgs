{ stdenv, lib, makeWrapper, kdeEnv }:

drv:

{ targets, paths ? [] }:

let
  env = kdeEnv drv paths;
in
stdenv.mkDerivation {
  inherit (drv) name;

  drv = lib.getBin drv;
  inherit env targets;
  passthru = { unwrapped = drv; };

  nativeBuildInputs = [ makeWrapper ];

  unpackPhase = "true";
  configurePhase = "runHook preConfigure; runHook postConfigure";
  buildPhase = "true";

  installPhase = ''
    for t in $targets; do
        if [ -a "$drv/$t" ]; then
            makeWrapper "$drv/$t" "$out/$t" \
                --argv0 '"$0"' \
                --suffix PATH : "$out/bin:$env/bin" \
                --prefix XDG_CONFIG_DIRS : "$env/etc/xdg" \
                --prefix XDG_DATA_DIRS : "$env/share" \
                --set QML_IMPORT_PATH "$env/lib/qt5/imports" \
                --set QML2_IMPORT_PATH "$env/lib/qt5/qml" \
                --set QT_PLUGIN_PATH "$env/lib/qt5/plugins"
        else
            echo "no such file or directory: $drv/$t"
            exit 1
        fi
    done

    mkdir -p "$out/nix-support"
    ln -s "$env/nix-support/propagated-user-env-packages" "$out/nix-support/"
  '';
}
