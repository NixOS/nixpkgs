#!/usr/bin/env nix-shell
#!nix-shell -i bash -p nix-update curl

new_version=$(curl https://armedbear.common-lisp.dev/ | grep abcl-src | sed 's;[^>]*>abcl-src-\(.*\).tar[^$]*;\1;' | head -n 1)
nix-update abcl --version "$new_version"
