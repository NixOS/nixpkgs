#!/usr/bin/env nix-shell
#!nix-shell -i bash -p yq jq common-updater-scripts dart

set -o errexit -o nounset -o pipefail

# TODO: Expand to get new version automatically once implemented upstream

SCRIPT_DIRECTORY=$(cd $(dirname ${BASH_SOURCE[0]}); cd -P $(dirname $(readlink ${BASH_SOURCE[0]} || echo .)); pwd)

cd -- "${SCRIPT_DIRECTORY}"

# Create new pubspec.lock.json
cleanup() {
    rm --force --recursive "${tmpdir}"
}
trap cleanup EXIT
tmpdir="$(mktemp -d)"

src="$(nix-build --no-link --attr unsure.src)"
cp "${src}"/pubspec.* "${tmpdir}"

if ! [[ -f pubspec.lock ]]; then
    dart pub --directory="${tmpdir}" update
fi

yq . "${tmpdir}/pubspec.lock" >"${SCRIPT_DIRECTORY}/pubspec.lock.json"
