addPerlLibPath () {
    if test -d $1/lib/site_perl; then
        export PERL5LIB="${PERL5LIB}${PERL5LIB:+:}$1/lib/site_perl"
    fi
}

envHooks=(${envHooks[@]} addPerlLibPath)
