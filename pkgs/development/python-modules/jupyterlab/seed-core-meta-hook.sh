# `jupyter labextension build` (jupyter-builder) needs @jupyterlab/core-meta's
# package.json, which is not present in the extension's node_modules. Rather than
# letting jupyter-builder download it from the network (which fails in the
# sandbox), seed its cache with JupyterLab's own staging/package.json — the exact
# file the builder would otherwise fetch.
#
# Registered in both postConfigureHooks and preBuildHooks: yarnBerryConfigHook
# only makes $HOME writable in postConfigure, and some extensions (e.g. bqscales)
# run the labextension build from their own preBuild attribute, which fires
# before preBuildHooks. Seeding in both phases covers every case; the copy is
# idempotent.
seedJupyterlabBuilderCoreMeta() {
    if [ -z "${HOME:-}" ] || ! mkdir -p "$HOME/.cache/jupyterlab_builder/core/main" 2>/dev/null; then
        return 0
    fi
    cp -f @out@/lib/python*/site-packages/jupyterlab/staging/package.json \
        "$HOME/.cache/jupyterlab_builder/core/main/package.json" 2>/dev/null || true
}

postConfigureHooks+=(seedJupyterlabBuilderCoreMeta)
preBuildHooks+=(seedJupyterlabBuilderCoreMeta)
