{ stdenv, lib, writeScript, coreutils, curl, gnugrep, gnused, jq, common-updater-scripts, nix }:
{ name, ignored-versions ? "^2014\\.|^v[0-9]+" }:

let
  nameAndVersion = builtins.parseDrvName name;
  packageVersion = nameAndVersion.version;
  packageName = nameAndVersion.name;
  attrPath = "deepin.${packageName}";
in

writeScript "update-${packageName}" ''
  #!${stdenv.shell}
  set -o errexit
  set -x

  # search for the latest version of the package on github
  PATH=${lib.makeBinPath [ common-updater-scripts coreutils curl gnugrep gnused jq ]}
  tags=$(curl -s https://api.github.com/repos/linuxdeepin/${packageName}/tags)
  tags=$(echo "$tags" | jq -r '.[] | .name')
  echo "# ${name}" >> git-commits.txt
  echo "#   available tags:" >> git-commits.txt
  echo "$tags" | ${gnused}/bin/sed -e 's/^/#      /' >> git-commits.txt
  if [ -n "${ignored-versions}" ]; then
    tags=$(echo "$tags" | grep -vE "${ignored-versions}")
  fi
  latest_tag=$(echo "$tags" | sort --version-sort | tail -1)

  # generate commands to commit the changes
  if [ "${packageVersion}" != "$latest_tag" ]; then
    pfile=$(EDITOR=echo ${nix}/bin/nix edit -f. ${attrPath})
    echo "   git add $pfile " >> git-commits.txt
    echo "   git commit -m \"${attrPath}: ${packageVersion} -> $latest_tag\"" >> git-commits.txt
  fi

  # update the nix expression
  update-source-version "${attrPath}" "$latest_tag"
  echo "" >> git-commits.txt
''
