addPerlLibPath () {
    addToSearchPath PERL5LIB $1/lib/site_perl
}

envHooks=(${envHooks[@]} addPerlLibPath)
