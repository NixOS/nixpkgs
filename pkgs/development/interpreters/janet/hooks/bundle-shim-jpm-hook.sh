# shellcheck shell=bash

janetBundleShimJpmHook() {
    echo "Executing janetBundleShimJpmHook"

    mkdir bundle

    cat << EOF > bundle/info.jdn
{:name "$pname"}
EOF

    cat << EOF > bundle/init.janet
(use @@spork@/lib/janet/spork/declare-cc)
(dofile "project.janet" :env (jpm-shim-env))
EOF

    echo "Finished janetBundleShimJpmHook"
}

postPatchHooks+=(janetBundleShimJpmHook)
