#!/bin/bash

splitBuildInstallExport() {

  echo "splitBuildInstallExport: copying /build to $out"
  cp -r /build $out

  echo "splitBuildInstallExport: creating empty outputs"
  # fix: builder failed to produce output path for output 'bin'
  for o in $outputs; do
    [ "$o" != 'out' ] && mkdir -v ${!o}
    # TODO generalize default output name
  done

  variables=""

  variables+="sourceRoot=$sourceRoot"$'\n'

  #suffixEscaped=$(echo $out | sha512sum -) # random
  #suffixEscaped=${suffixEscaped:0:11}
  #variables+="suffixEscaped=$suffixEscaped"$'\n'

  suffix="-$name"
  suffixLength=${#suffix}
  variables+="suffix=$suffix"$'\n'

  suffixEscaped=$(echo $out | sha512sum -) # random
  suffixEscaped=${suffixEscaped:0:$suffixLength}
  variables+="suffixEscaped=$suffixEscaped"$'\n'

  echo "splitBuildInstallExport: replacing suffix:"
  echo "  a: $suffix"
  echo "  b: $suffixEscaped"

  # set outHash binHash devHash
  for o in $outputs; do
    p=${!o}
    h=${p:11:32}
    declare ${o}Hash=$h
    variables+="${o}Hash=$h"$'\n' # cache for drv2
  done

  echo "splitBuildInstallExport: storing variables in $out/splitBuildInstall.variables.sh"
  echo "$variables" >$out/splitBuildInstall.variables.sh

  # a: /nix/store/a3vjswd3i42xy5hzxras78z0m40g9jk7-qtbase-6.2.0
  # b: /nix/store/a3vjswd3i42xy5hzxras78z0m40g9jk7xxxxxxxxxxxxx
  #               ^ outHash: 32 chars             ^ suffixEscaped: variable length

  re_grep="("
  isFirst=true
  for o in $outputs; do
    k=${o}Hash
    h=${!k}
    if $isFirst; then isFirst=false; else re_grep+='|'; fi
    re_grep+=$h
  done
  re_grep+=")$suffix"

  re_sed="s,$re_grep,\1$suffixEscaped,g"

  echo "splitBuildInstallExport: debug: re_grep = $re_grep"
  echo "splitBuildInstallExport: debug: re_sed = $re_sed"

  (
    cd "$out"
    grep -r -l -Z -E "$re_grep" | tee "$out/splitBuildInstall.patchedFiles.txt" | xargs -0 sed -i -E "$re_sed"
  )

  n=$(stat -c%s $out/splitBuildInstall.patchedFiles.txt)
  if [ $n = 0 ]; then
    echo "splitBuildInstallExport: fatal error: no install paths were replaced"
    exit 1
  fi
  echo "splitBuildInstallExport: replaced install paths. see $out/splitBuildInstall.patchedFiles.txt"
}
