addPerlLibPath () {
    addToSearchPath PERL5LIB $1/@libPrefix@
}

envHooks+=(addPerlLibPath)
