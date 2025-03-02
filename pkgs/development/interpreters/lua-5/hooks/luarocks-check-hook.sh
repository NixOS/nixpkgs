# Setup hook for checking whether Python imports succeed
echo "Sourcing luarocks-check-hook.sh"

luarocksCheckPhase () {
    echo "Executing luarocksCheckPhase"
    runHook preCheck

    luarocks test

    runHook postCheck
    echo "Finished executing luarocksCheckPhase"
}

if [ -z "${dontLuarocksCheck-}" ] && [ -z "${checkPhase-}" ]; then
    echo "Using luarocksCheckPhase"
    checkPhase+=" luarocksCheckPhase"
fi

