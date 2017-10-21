make_grilo_find_plugins() {
    if [ -d "$1"/lib/grilo-0.3 ]; then
        addToSearchPath GRL_PLUGIN_PATH "$1/lib/grilo-0.3"
    fi
}

envHooks+=(make_grilo_find_plugins)
