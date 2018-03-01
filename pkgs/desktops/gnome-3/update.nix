{ lib, writeScript, python3, common-updater-scripts, coreutils, gnugrep, gnused }:
{ packageName, attrPath ? packageName, versionPolicy ? "odd-unstable" }:

let
  python = python3.withPackages (p: [ p.requests ]);
in writeScript "update-${packageName}" ''
  set -o errexit
  PATH=${lib.makeBinPath [ common-updater-scripts coreutils gnugrep gnused python ]}
  latest_tag=$(python "${./find-latest-version.py}" "${packageName}" "${versionPolicy}" "stable")
  update-source-version "${attrPath}" "$latest_tag"
''
