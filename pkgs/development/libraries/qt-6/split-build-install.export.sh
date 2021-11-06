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

  regex="s,("
  isFirst=true
  for o in $outputs; do
    k=${o}Hash
    h=${!k}
    if $isFirst; then isFirst=false; else regex+='|'; fi
    regex+=$h
  done
  regex+=")$suffix,\1$suffixEscaped,g w /dev/stdout"

  echo "splitBuildInstallExport: debug: regex = $regex"

  # note: the output paths also appear in binary files = *.so, etc
  # so we use the same length as the original path
  # tr -d '\0': fix "ignored null byte" when replacing binary files
  touch $out/splitBuildInstall.patchedFiles.txt
  (
    cd $out
    find . -type f | while read f; do
      if [ -n "$(sed -i -E "$regex" "$f" | tr -d '\0')" ]; then
        # file was replaced
        echo "$f" >>$out/splitBuildInstall.patchedFiles.txt
      fi
    done
  )
  n=$(wc -l $out/splitBuildInstall.patchedFiles.txt | cut -d' ' -f1)
  if [ "$n" = '0' ]; then
    echo "splitBuildInstallExport: fatal error: no install paths were replaced"
    exit 1
  fi
  echo "splitBuildInstallExport: replaced install paths in $n files. see $out/splitBuildInstall.patchedFiles.txt"
}
