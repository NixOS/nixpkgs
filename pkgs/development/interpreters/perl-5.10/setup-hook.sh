addPerlLibPath () {
    addToSearchPath PERL5LIB $1/lib/perl5/site_perl
}

envHooks=(${envHooks[@]} addPerlLibPath)
