# `jupyter labextension build` (jupyter-builder) needs @jupyterlab/core-meta's
# core.package.json. Extensions whose lockfile pins an @jupyterlab/builder older
# than 4.6 do not get it in their node_modules, and jupyter-builder then
# downloads it from npm/GitHub, which fails in the sandbox.
#
# jupyter-builder looks for node_modules/@jupyterlab/core-meta/core.package.json
# walking up from the extension directory, so seeding $NIX_BUILD_TOP covers every
# extension regardless of its source layout or of the version it requests. The
# file it would otherwise download is JupyterLab's own staging/package.json.
#
# Registered in both postConfigureHooks and preBuildHooks: yarnBerryConfigHook
# only makes $HOME writable in postConfigure, and some extensions (e.g. bqscales)
# run the labextension build from their own preBuild attribute, which fires
# before preBuildHooks. Seeding in both phases covers every case; the copy is
# idempotent.
seedJupyterlabBuilderCoreMeta() {
    local coreMetaDir="${NIX_BUILD_TOP:-}/node_modules/@jupyterlab/core-meta"
    if [ -z "${NIX_BUILD_TOP:-}" ] || ! mkdir -p "$coreMetaDir" 2>/dev/null; then
        return 0
    fi
    cp -f @out@/lib/python*/site-packages/jupyterlab/staging/package.json \
        "$coreMetaDir/core.package.json" 2>/dev/null || true
}

postConfigureHooks+=(seedJupyterlabBuilderCoreMeta)
preBuildHooks+=(seedJupyterlabBuilderCoreMeta)
