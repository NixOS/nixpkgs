addPerlLibPath () {
    addToSearchPath PERL5LIB /lib/site_perl "" $1
}

envHooks=(${envHooks[@]} addPerlLibPath)
