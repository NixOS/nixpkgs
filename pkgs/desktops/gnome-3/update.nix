{ stdenv, pkgs, lib, writeScript, python3, common-updater-scripts }:
{ packageName, attrPath ? packageName, versionPolicy ? "odd-unstable", freeze ? true }:

let
  python = python3.withPackages (p: [ p.requests ]);
  upperBoundFlag =
    let
      package = lib.attrByPath (lib.splitString "." attrPath) (throw "Cannot find attribute ‘${attrPath}’.") pkgs;
      packageVersion = lib.getVersion package;
      versionComponents = lib.versions.splitVersion packageVersion;
      minorVersion = lib.versions.minor packageVersion;
      minorAvailable = builtins.length versionComponents > 1 && builtins.match "[0-9]+" minorVersion != null;
      nextMinor = builtins.fromJSON minorVersion + 1;
      upperBound = "${lib.versions.major packageVersion}.${builtins.toString nextMinor}";
    in lib.optionalString (freeze && minorAvailable) ''--upper-bound="${upperBound}"'';
  updateScript = writeScript "gnome-update-script" ''
    #!${stdenv.shell}
    set -o errexit
    package_name="$1"
    attr_path="$2"
    version_policy="$3"
    PATH=${lib.makeBinPath [ common-updater-scripts python ]}
    latest_tag=$(python "${./find-latest-version.py}" "$package_name" "$version_policy" "stable" ${upperBoundFlag})
    update-source-version "$attr_path" "$latest_tag"
  '';
in [ updateScript packageName attrPath versionPolicy ]
