# luarocks installs data in a non-overridable location. Until a proper luarocks patch,
# we move the files around ourselves
echo "Sourcing luarocks-move-data-hook.sh"

luarocksMoveDataHook () {
    echo "Executing luarocksMoveDataHook"
    if [ -d "$out/$rocksSubdir" ]; then
        cp -rfv "$out/$rocksSubdir/$pname/$rockspecVersion/." "$out"
    fi

    echo "Finished executing luarocksMoveDataHook"
}

echo "Using luarocksMoveDataHook"
preFixupHooks+=(luarocksMoveDataHook)
