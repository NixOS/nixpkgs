make_grilo_find_plugins() {
    if [ -d "$1"/lib/grilo-0.2 ]; then
        addToSearchPath GRL_PLUGIN_PATH "$1/lib/grilo-0.2"
    fi
}

envHooks+=(make_grilo_find_plugins)
