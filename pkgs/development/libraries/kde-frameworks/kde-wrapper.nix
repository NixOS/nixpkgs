{ stdenv, lib, makeWrapper, buildEnv }:

packages:

let
  packages_ = if builtins.isList packages then packages else [packages];

  unwrapped = lib.concatMap (p: if builtins.isList p.unwrapped then p.unwrapped else [p.unwrapped]) packages_;
  targets = lib.concatMap (p: p.targets) packages_;
  paths = lib.concatMap (p: p.paths or []) packages_;

  name =
    if builtins.length unwrapped == 1
    then (lib.head unwrapped).name
    else "kde-application";
  meta =
    if builtins.length unwrapped == 1
    then (lib.head unwrapped).meta
    else {};

  env = buildEnv {
    inherit name meta;
    paths = builtins.map lib.getBin (unwrapped ++ paths);
    pathsToLink = [ "/bin" "/share" "/lib/qt5" "/etc/xdg" ];
  };
in

stdenv.mkDerivation {
  inherit name meta;
  preferLocalBuild = true;

  inherit unwrapped env targets;

  passthru = {
    inherit targets paths;
    unwrapped = if builtins.length unwrapped == 1 then lib.head unwrapped else unwrapped;
  };

  nativeBuildInputs = [ makeWrapper ];

  buildCommand = ''
    for t in $targets; do
        good=""
        for drv in $unwrapped; do
            if [ -a "$drv/$t" ]; then
                makeWrapper "$drv/$t" "$out/$t" \
                    --argv0 '"$0"' \
                    --suffix PATH : "$env/bin" \
                    --prefix XDG_CONFIG_DIRS : "$env/etc/xdg" \
                    --prefix XDG_DATA_DIRS : "$env/share" \
                    --set QML_IMPORT_PATH "$env/lib/qt5/imports" \
                    --set QML2_IMPORT_PATH "$env/lib/qt5/qml" \
                    --set QT_PLUGIN_PATH "$env/lib/qt5/plugins"
                good="1"
                break
            fi
        done
        if [ -z "$good" ]; then
            echo "file or directory not found in derivations: $t"
            exit 1
        fi
    done

    mkdir -p "$out/nix-support"
    echo "$unwrapped" > "$out/nix-support/propagated-user-env-packages"
  '';
}
