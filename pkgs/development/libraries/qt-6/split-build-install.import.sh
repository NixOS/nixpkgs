

splitBuildInstallImport() {

  echo "splitBuildInstallImport: installing from cached build $src"

  # set: sourceRoot suffixEscaped outHash binHash devHash ...
  echo "splitBuildInstallImport: sourcing $src/splitBuildInstall.variables.sh"
  . $src/splitBuildInstall.variables.sh

  echo "splitBuildInstallImport: copying cached build files ..."
  t1=$(date +%s)
  cp -r $src/$sourceRoot /build/
  echo "splitBuildInstallImport: copying cached build files done in $(($(date +%s) - $t1)) seconds"

  chmod -R +w /build

  # set outHashNew binHashNew devHashNew ...
  for o in $outputs; do
    p=${!o}
    h=${p:11:32}
    declare ${o}HashNew=$h
  done

  # replace install paths
  echo "splitBuildInstallImport: replacing output hashes:"
  for o in $outputs; do
    a=${o}Hash
    b=${o}HashNew
    echo "  $o: ${!a} -> ${!b}"
  done

  echo "splitBuildInstallImport: debug: regex:"
  regexStr=""
  isFirst=true
  for o in $outputs; do
    a=${o}Hash
    b=${o}HashNew
    regex="s,${!a}$suffixEscaped,${!b}$suffix,g;"
    echo "  $o: $regex"
    regexStr+="$regex"
  done

  (
    cd /build
    cat $src/splitBuildInstall.patchedFiles.txt | xargs -0 sed -i "$regexStr"
  )

  if false; then
    # debug: verify patched output paths (slow)
    regex=".{50}("
    isFirst=true
    for o in $outputs; do
      k=${o}Hash
      h=${!k}
      if $isFirst; then isFirst=false; else regex+='|'; fi
      regex+=$h
    done
    regex+=").{50}"

    echo "splitBuildInstallImport: test replacement of old hashes ..."
    echo "  regex = $regex"

    grepResult="$(find /build -type f -not -path /build/env-vars -print0 | xargs -0 grep -HnEa "$regex" || true)"
    if [ -n "$grepResult" ]; then
    echo "splitBuildInstallImport: fatal error: some hashes were not replaced:"
    echo "$grepResult"
    exit 1
    fi

    echo "splitBuildInstallImport: debug: diff cmake_install.cmake:"
    diff -u0 $src/$sourceRoot/build/cmake_install.cmake /build/$sourceRoot/build/cmake_install.cmake || true
  fi

  cd /build/$sourceRoot/build
}
