# luarocks installs data in a non-overridable location. Until a proper luarocks patch,
# we move the files around ourselves
echo "Sourcing luarocks-move-data-hook.sh"

luarocksMoveDataHook () {
    echo "Executing luarocksMoveDataHook"
    if [ -d "$out/$rocksSubdir" ]; then
        cp -rfv "$out/$rocksSubdir/$pname/$version/." "$out"
    fi

    echo "Finished executing luarocksMoveDataHook"
}

echo "Using luarocksMoveDataHook"
preDistPhases+=" luarocksMoveDataHook"
