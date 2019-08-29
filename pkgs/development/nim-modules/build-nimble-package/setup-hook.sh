# Utility function: echo the base name of the given path, with the
# prefix `HASH-' removed, if present.
stripHash() {
    local strippedName
    # On separate line for `set -e`
    strippedName="$(basename "$1")"
    if echo "$strippedName" | grep -q '^[a-z0-9]\{32\}-'; then
        echo "$strippedName" | cut -c34-
    else
        echo "$strippedName"
    fi
}

addNimblePackage () {
	export NIMBLE_DIR="$NIX_BUILD_TOP/.nimble"
	local NAME=$(stripHash $1)
	if [ -d "$1/nimble-pkgs/$NAME" ]; then
		mkdir -p "$NIMBLE_DIR/pkgs"
		cp -ru "$1/nimble-pkgs/$NAME" "$NIMBLE_DIR/pkgs/"
		chmod +w -R "$NIMBLE_DIR/pkgs/$NAME"
	fi
}

addEnvHooks "$hostOffset" addNimblePackage
