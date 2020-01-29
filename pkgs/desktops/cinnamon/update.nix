{ stdenv, lib, writeScript, callPackage, common-updater-scripts }:
{
  pname
, attrPath ? "cinnamon.${pname}"

, gh_repo ? pname
, gh_owner ? "linuxmint"
, gh_url ? "${gh_owner}/${gh_repo}"

, semver ? ""
}:

let
  bin = callPackage ./gh_update { };
  updateScript = writeScript "cinnamon-update-script" ''
    #!${stdenv.shell}
    set -o errexit
    attr_path="$1"
    slug="$2"
    semver_policy="$3"
    PATH=${lib.makeBinPath [ common-updater-scripts bin ]}
    latest_tag=$(gh_update "$slug" "$semver_policy")
    update-source-version "$attr_path" "$latest_tag"
  '';
in [ updateScript attrPath gh_url semver ]
