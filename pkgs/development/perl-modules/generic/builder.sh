source $stdenv/setup

PERL5LIB="$PERL5LIB${PERL5LIB:+:}$out/lib/perl5/site_perl"

perlFlags=
for i in $(IFS=:; echo $PERL5LIB); do
    # exclude paths pointing to perl derivation (like /nix/store/abcdfghijklmnpqrsvwxyz0123456789-perl-5.28.2/lib/perl5/site_perl)
    # they are needless pointing to correct perl, and source of subtle bugs pointing to another perl
    if [[ ! $i =~ /[0123456789abcdfghijklmnpqrsvwxyz]{32}-perl-[0-9.]+/lib/perl5/site_perl$ ]] && [[ $perlFlags != *" -I$i"* ]]; then
        perlFlags="$perlFlags -I$i"
    fi
done

oldPreConfigure="$preConfigure"
preConfigure() {

    eval "$oldPreConfigure"

    find . | while read fn; do
        if test -f "$fn"; then
            first=$(dd if="$fn" count=2 bs=1 2> /dev/null)
            if test "$first" = "#!"; then
                echo "patching $fn..."
                sed -i "$fn" -e "s|^#\!\(.*\bperl\b.*\)$|#\!\1$perlFlags|"
            fi
        fi
    done

    perl Makefile.PL PREFIX=$out INSTALLDIRS=site $makeMakerFlags PERL=$(type -P perl) FULLPERL=\"$fullperl/bin/perl\"
}


postFixup() {
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
