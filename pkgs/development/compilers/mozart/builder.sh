#!/bin/bash

source $stdenv/setup

echo "unpacking $src..."
tar xvfz $src

mkdir -p $out/bin
mkdir -p $out/share

mv mozart*linux/bin/* $out/bin
mv mozart*linux/share/* $out/share

patchShebangs $out

for f in $out/bin/*; do
  b=$(basename $f)
  if [ $b == "ozemulator" ] || [ $b == "ozwish" ]; then
     patchelf --interpreter "$(cat $NIX_GCC/nix-support/dynamic-linker)" \
	 --set-rpath $libPath \
	 $f
    continue;
  fi
  wrapProgram $f \
    --set OZHOME $out
done
