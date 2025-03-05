#!/usr/bin/env nix-shell
#! nix-shell -I nixpkgs=../../../../.. -i oil -p oil chicken

export URL_PREFIX="https://code.call-cc.org/egg-tarballs/5/"
cd $(nix-prefetch-url \
     'https://code.call-cc.org/cgi-bin/gitweb.cgi?p=eggs-5-latest.git;a=snapshot;h=master;sf=tgz' \
     --name chicken-eggs-5-latest --unpack --print-path | tail -1)

echo "# THIS IS A GENERATED FILE.  DO NOT EDIT!" > $_this_dir/deps.toml
for i, item in */*/*.egg {
  var EGG_NAME=$(dirname $(dirname $item))
  var EGG_VERSION=$(basename $(dirname $item))
  var EGG_URL="${URL_PREFIX}${EGG_NAME}/${EGG_NAME}-${EGG_VERSION}.tar.gz"
  var EGG_SHA256=$(nix-prefetch-url $EGG_URL)
  export EGG_NAME
  export EGG_VERSION
  export EGG_SHA256
  csi -s $_this_dir/read-egg.scm < $item
} >> $_this_dir/deps.toml
