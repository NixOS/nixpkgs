addPerlLibPath () {
    addToSearchPath PERL5LIB $1/lib/perl5/site_perl/@version@
    addToSearchPath PERL5LIB $1/lib/perl5/site_perl/cross_perl/@version@
    # Adding the arch-specific directory is morally incorrect, as
    # miniperl can't load the native modules there. However, it can
    # (and sometimes needs to) load and run some of the pure perl
    # code there, so we add it anyway. When needed, stubs can be put
    # into $1/lib/perl5/site_perl/cross_perl/@version@
    addToSearchPath PERL5LIB $1/lib/perl5/site_perl/@version@/@runtimeArch@
}

addEnvHooks "$hostOffset" addPerlLibPath
