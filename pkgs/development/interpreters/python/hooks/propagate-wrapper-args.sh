# Hook that propagates wrapper arguments up to the
# python interpreter buildEnv environment.
echo "Sourcing propagate-wrapper-args.sh"

storeWrapperArgsHook() {
    # Store the arguments for use by other derivations
    # and the python interpreter derivation.
    echo "Executing propagateWrapperArgsHook"

    mkdir -p "$out/nix-support"
    if [ ${#qtWrapperArgs[@]} -ne 0 ]; then
        printf '%s\n' "${qtWrapperArgs[@]}" >> "$out/nix-support/make-wrapper-args"
    fi
    if [ ${#gappsWrapperArgs[@]} -ne 0 ]; then
        printf '%s\n' "${gappsWrapperArgs[@]}" >> "$out/nix-support/make-wrapper-args"
    fi
    if [ ${#makeWrapperArgs[@]} -ne 0 ]; then
        printf '%s\n' "${makeWrapperArgs[@]}" >> "$out/nix-support/make-wrapper-args"
    fi
}

loadWrapperArgsHook() {
    # Load the arguments from all the dependencies.
    # Note: this hook *must* run after storeWrapperArgsHook to
    # avoid an exponential duplication of the wrapper arguments.
    for path in $propagatedBuildInputs "$@"; do
        if [ -f "$path/nix-support/make-wrapper-args" ]; then
            makeWrapperArgs+=$(cat "$path/nix-support/make-wrapper-args")
        fi
    done
}

postFixupHooks+=(storeWrapperArgsHook loadWrapperArgsHook)
