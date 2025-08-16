#!/usr/bin/env nix-shell
#! nix-shell -I nixpkgs=../../../../.. -i ysh -p oils-for-unix chickenPackages_5.chicken nix gzip gnutar

const egg_base_url = "https://code.call-cc.org/egg-tarballs/5/"

const _, index_file = \
      @(nix-prefetch-url \
          'https://code.call-cc.org/egg-tarballs/5/index.gz' \
          --name chicken-eggs-5-index \
          --print-path)

echo "# THIS IS A GENERATED FILE.  DO NOT EDIT!" > $_this_dir/deps.toml

gzip -dc $index_file |
  csi -s $_this_dir/read-egg-index.scm |
  for egg in (io.stdin) {
    const egg_name, egg_version, egg_sha1 = split(egg, b'\t')
    const egg_url = "${egg_base_url}${egg_name}/${egg_name}-${egg_version}.tar.gz"

    const _, egg_tarball = \
          @(nix-prefetch-url $egg_url \
                             $egg_sha1 \
                             --type sha1 \
                             --name "${egg_name}.tar.gz" \
                             --print-path)

    const egg_sha256 = \
          $(nix-hash \
              --type sha256 \
              --base32 \
              --flat \
              $egg_tarball)

    tar xOf $egg_tarball "${egg_name}-${egg_version}/${egg_name}.egg" | (
      EGG_NAME=$egg_name \
        EGG_SHA256=$egg_sha256 \
        EGG_VERSION=$egg_version \
        csi -s $_this_dir/read-egg.scm
    )
  } >> $_this_dir/deps.toml
