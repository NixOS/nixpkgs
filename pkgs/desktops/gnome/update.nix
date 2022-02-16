{ stdenv, pkgs, lib, writeScript, python3, common-updater-scripts }:
{ packageName, attrPath ? packageName, versionPolicy ? "tagged", freeze ? false }:

let
  python = python3.withPackages (p: [ p.requests p.libversion ]);
  package = lib.attrByPath (lib.splitString "." attrPath) (throw "Cannot find attribute ‘${attrPath}’.") pkgs;
  packageVersion = lib.getVersion package;
  upperBoundFlag =
    let
      versionComponents = lib.versions.splitVersion packageVersion;
      minorVersion = lib.versions.minor packageVersion;
      minorAvailable = builtins.length versionComponents > 1 && builtins.match "[0-9]+" minorVersion != null;
      nextMinor = builtins.fromJSON minorVersion + 1;
      upperBound = "${lib.versions.major packageVersion}.${builtins.toString nextMinor}";
    in lib.optionalString (freeze && minorAvailable) ''--upper-bound="${upperBound}"'';
  updateScript = writeScript "gnome-update-script" ''
    #!${stdenv.shell}
    set -o errexit
    attr_path="$1"
    package_name="$2"
    package_version="$3"
    version_policy="$4"
    PATH=${lib.makeBinPath [ common-updater-scripts python ]}
    latest_tag=$(python "${./find-latest-version.py}" "$package_name" "$version_policy" "stable" ${upperBoundFlag})
    update-source-version "$attr_path" "$latest_tag"
    echo '[ { "commitBody": "https://gitlab.gnome.org/GNOME/'$package_name'/-/compare/'$package_version'...'$latest_tag'" } ]'
  '';
in {
  name = "gnome-update-script";
  command = [ updateScript attrPath packageName packageVersion versionPolicy ];
  supportedFeatures = [
    "commit"
  ];
}
