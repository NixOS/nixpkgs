# Fix 'failed to open: /homeless-shelter/.cargo/.package-cache' in rust 1.36.
if [[ -z ${IN_NIX_SHELL-} && -z ${CARGO_HOME-} ]]; then
    export CARGO_HOME=$TMPDIR
fi
