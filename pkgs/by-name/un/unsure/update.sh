#!/usr/bin/env nix-shell
#!nix-shell -i bash -p yq jq common-updater-scripts dart

set -o errexit -o nounset -o pipefail

# TODO: Expand to get new version automatically once implemented upstream

package_dir="$(dirname "${BASH_SOURCE[0]}")"

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

yq . "${tmpdir}/pubspec.lock" >"${package_dir}/pubspec.lock.json"
