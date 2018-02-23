source $stdenv/setup

export PERL5LIB="$PERL5LIB${PERL5LIB:+:}$out/lib/perl5/site_perl"

oldPreConfigure="$preConfigure"
preConfigure() {
    eval "$oldPreConfigure"

    perl Makefile.PL PREFIX=$out INSTALLDIRS=site $makeMakerFlags PERL=$(type -P perl) FULLPERL=\"$perl/bin/perl\"
}

postFixup() {
    if test -d "$out/bin"; then
        fileList="$(find "$out/bin")"
        echo "$fileList" | while read fn; do
            if test -f "$fn"; then
                wrapProgram "$fn" --prefix PERL5LIB : "$PERL5LIB"
            fi
        done
    fi

    # If a user installs a Perl package, she probably also wants its
    # dependencies in the user environment (since Perl modules don't
    # have something like an RPATH, so the only way to find the
    # dependencies is to have them in the PERL5LIB variable).
    if test -e $out/nix-support/propagated-build-inputs; then
        ln -s $out/nix-support/propagated-build-inputs $out/nix-support/propagated-user-env-packages
    fi
}

if test -n "$perlPreHook"; then
    eval "$perlPreHook"
fi

genericBuild

if test -n "$perlPostHook"; then
    eval "$perlPostHook"
fi
