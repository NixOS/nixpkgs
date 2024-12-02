{
  lib,
  stdenv,
  common-updater-scripts,
  coreutils,
  depotdownloader,
  gnugrep,
  gnused,
  steamctl,
  jq,
  nix,
  writeScript,
}:

{
  name ? null,
  pname ? null,
  version ? null,
  attrPath ? null,
  # Explicit Steam appId required for the update script to work.
  appId ? null,
}:

let
  # shell script to update package
  updateScript = writeScript "generic-update-script.sh" ''
    #! ${stdenv.shell}

    # Set strict shell mode and enable debugging
    set -o errexit
    set -x

    # Add utilities to PATH
    export PATH=${
      lib.makeBinPath [
        "${common-updater-scripts}/bin"
        "${depotdownloader}/bin"
        "${gnugrep}/bin"
        "${gnused}/bin"
        "${jq}/bin"
        "${steamctl}/bin"
      ]
    }:$PATH

    # Get necessary variables
    name="$1"
    pname="$2"
    version="$3"
    attr_path="$4"
    app_id="$5"

    [[ -n "$name" ]] || name="$UPDATE_NIX_NAME"
    [[ -n "$pname" ]] || pname="$UPDATE_NIX_PNAME"
    [[ -n "$version" ]] || version="$UPDATE_NIX_OLD_VERSION"
    [[ -n "$attr_path" ]] || attr_path="$UPDATE_NIX_ATTR_PATH"

    # Use steamctl to get information about latest depots
    APP_INFO=$(steamctl -l quiet --anonymous depot info --app $app_id)
    LATEST_VERSION=$(echo $APP_INFO | grep -oP 'Created On: \K[0-9\-]+' | sort -r | head -n 1)
    DEPOT_IDS=$(echo $APP_INFO | grep -oP 'Depot ID: \K[0-9]+')
    MANIFEST_GIDS=$(echo $APP_INFO | grep -oP 'Manifest GID: \K[0-9]+')
  '';

in
{
  name = "steam-update-script";
  command = [
    updateScript
    name
    pname
    version
    attrPath
    appId
  ];
  supportedFeatures = [
    # Stdout must contain output according to the updateScript commit protocol when the update script finishes with a non-zero exit code.
    "commit"
  ];
}
