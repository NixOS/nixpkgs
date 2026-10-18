# shellcheck shell=bash
# Setup hook for .NET workload packs.
# Sets DOTNETSDK_WORKLOAD_PACK_ROOTS so the SDK can find pre-installed workload packs.

addWorkloadPackRoot() {
    local sep=${DOTNETSDK_WORKLOAD_PACK_ROOTS:+:}
    export DOTNETSDK_WORKLOAD_PACK_ROOTS="${DOTNETSDK_WORKLOAD_PACK_ROOTS:-}${sep}@workloadPackRoot@/share/dotnet"
}
addWorkloadPackRoot
