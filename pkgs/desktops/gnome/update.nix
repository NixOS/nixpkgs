{ stdenv, bash, pkgs, lib, writeScript, python3, common-updater-scripts }:
{ packageName, attrPath ? packageName, versionPolicy ? "tagged", freeze ? false }:

let
  python = python3.withPackages (p: [ p.requests p.libversion ]);
  package = lib.attrByPath (lib.splitString "." attrPath) (throw "Cannot find attribute ‘${attrPath}’.") pkgs;
  packageVersion = lib.getVersion package;
  upperBound =
    let
      versionComponents = lib.versions.splitVersion packageVersion;
      minorVersion = lib.versions.minor packageVersion;
      minorAvailable = builtins.length versionComponents > 1 && builtins.match "[0-9]+" minorVersion != null;
      nextMinor = builtins.fromJSON minorVersion + 1;
      upperBound = "${lib.versions.major packageVersion}.${builtins.toString nextMinor}";
    in lib.optionals (freeze && minorAvailable) [ upperBound ];
  updateScript = writeScript "gnome-update-script" ''
    #!${bash}/bin/bash
    set -o errexit
    attr_path="$1"
    package_name="$2"
    package_version="$3"
    version_policy="$4"

    flvFlags=("$package_name" "$version_policy" "''${GNOME_UPDATE_STABILITY:-stable}")

    if (( $# >= 5 )); then
      upper_bound="$5"
      flvFlags+=("--upper-bound=$upper_bound")
    fi

    PATH=${lib.makeBinPath [ common-updater-scripts python ]}
    latest_tag=$(python "${./find-latest-version.py}" "''${flvFlags[@]}")
    update-source-version "$attr_path" "$latest_tag"
    echo '[ { "commitBody": "https://gitlab.gnome.org/GNOME/'$package_name'/-/compare/'$package_version'...'$latest_tag'" } ]'
  '';
in {
  name = "gnome-update-script";
  command = [ updateScript attrPath packageName packageVersion versionPolicy ] ++ upperBound;
  supportedFeatures = [
    "commit"
  ];
}
