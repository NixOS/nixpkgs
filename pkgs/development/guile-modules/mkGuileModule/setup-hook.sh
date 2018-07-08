addGuilePath() {
    addToSearchPath GUILE_LOAD_PATH "$1/share/guile/site"
    # FIXME: parameterize "2.2"
    addToSearchPath GUILE_LOAD_COMPILED_PATH "$1/lib/guile/2.2/site-ccache"
}

addEnvHooks "$targetOffset" addGuilePath
