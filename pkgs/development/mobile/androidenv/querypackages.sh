#!/bin/sh -e

if [ "$1" = "" ]
then
    echo "Please select a package set: 'packages', 'addons', 'system-images'" >&2
    exit 1
fi

if [ "$2" = "" ]
then
    echo "Please select a package group:" >&2
    ( cat <<EOF
builtins.attrNames (import ./generated/$1.nix {
  fetchurl = null;
})
EOF
) | nix-instantiate --eval-only -

    exit 1
fi

( cat <<EOF
builtins.attrNames (import ./generated/$1.nix {
  fetchurl = null;
}).$2
EOF
) | nix-instantiate --eval-only -
