addPerlLibPath () {
    prependToSearchPath PERL5LIB $1/lib/perl5/site_perl
}

envHooks+=(addPerlLibPath)
