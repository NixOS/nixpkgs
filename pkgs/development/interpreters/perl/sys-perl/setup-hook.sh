addPerlLibPath () {
    addToSearchPath PERL5LIB $1/lib/perl5/site_perl/5.10/i686-cygwin
}

envHooks=(${envHooks[@]} addPerlLibPath)
