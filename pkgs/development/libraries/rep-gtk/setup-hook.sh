addRepDLLoadPath () {
    prependToSearchPath REP_DL_LOAD_PATH $1/lib/rep
}

envHooks+=(addRepDLLoadPath)
