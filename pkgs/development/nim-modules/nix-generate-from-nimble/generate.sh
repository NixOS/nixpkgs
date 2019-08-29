#! /usr/bin/env bash

set -eu -o pipefail

usage(){
echo  >&2 "syntax: nix-generate-from-nimble [NIMBLE-PACKAGE-NAME]

Fetch the Nimble package list, prefetch the package source, and generate a
directory at NIMBLE-PACKAGE-NAME containing an initial Nix package.
"
	exit 1
}

NIMBLE_NAME=
argi=0
argfun=""
for arg; do
	: $((++argi))
	case $argi in
	1) NIMBLE_NAME=$arg;;
	*) exit 1;;
	esac
done

if test -z "$NIMBLE_NAME"; then
	usage
fi

HOME=${TMPDIR:=/tmp}/nix-generate-from-nimble

remove_home(){
	rm -rf ${TMPDIR:=/tmp}/nix-generate-from-nimble
}
trap remove_home EXIT

nimble refresh

mkdir -p "$NIMBLE_NAME"
pushd "$NIMBLE_NAME"

META_NIMBLE=$(
	nimble search --json --ver "$NIMBLE_NAME" \
	| jq --compact-output "map(select(.name==\"$NIMBLE_NAME\")) | .[0]")

SRC_METHOD=$(jq ".method" <<< "$META_NIMBLE" | xargs)
SRC_URL=$(jq ".url" <<< "$META_NIMBLE" | xargs)
SRC_REV=$(jq '.versions | .[0]' <<< "$META_NIMBLE" | xargs)
VERSION=$SRC_REV

if [ "$SRC_REV" == "null" ]; then
	SRC_REV=
	VERSION=0.1.0
fi

case "$SRC_METHOD" in
	git)
	SRC_FUNC=fetchgit
	META_SRC=$(nix-prefetch-git --fetch-submodules --quiet $SRC_URL $SRC_REV)
	;;

	*)
	echo "Unhandled fetch method \"$SRC_METHOD\""
	exit 1
	;;
esac

test -z "$META_SRC" && exit 1

# Pretty print metadata into 'nimble.json'
jq <<< "{ \"nimble\": $META_NIMBLE, \"src\": $META_SRC }" > nimble.json

# Create a default.nix
cat <<-EOF > default.nix
{ buildNimblePackage, $SRC_FUNC }:
let json = with builtins; fromJSON (readFile ./nimble.json);
in buildNimblePackage {
  nimbleMeta = json.nimble;
  version = "$VERSION";
  src = $SRC_FUNC { inherit (json.src) url rev sha256 fetchSubmodules; };
}
EOF
