{ stdenv, lib, writeScript, python3, common-updater-scripts, coreutils, gnugrep, gnused }:
{ packageName, attrPath ? packageName, versionPolicy ? "odd-unstable" }:

let
  python = python3.withPackages (p: [ p.requests ]);
  updateScript = writeScript "gnome-update-script" ''
    #!${stdenv.shell}
    set -o errexit
    package_name="$1"
    attr_path="$2"
    version_policy="$3"
    PATH=${lib.makeBinPath [ common-updater-scripts coreutils gnugrep gnused python ]}
    latest_tag=$(python "${./find-latest-version.py}" "$package_name" "$version_policy" "stable")
    update-source-version "$attr_path" "$latest_tag"
  '';
in [ updateScript packageName attrPath versionPolicy ]
