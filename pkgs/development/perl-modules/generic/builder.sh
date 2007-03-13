source $stdenv/setup

PERL5LIB="$PERL5LIB${PERL5LIB:+:}$out/lib/site_perl"

oldIFS=$IFS
IFS=:
perlFlags=
for i in $PERL5LIB; do
    perlFlags="$perlFlags -I$i"
done
IFS=$oldIFS
echo "Perl flags: $perlFlags"

preConfigure=preConfigure
preConfigure() {

    find . | while read fn; do
        if test -f "$fn"; then
            first=$(dd if="$fn" count=2 bs=1 2> /dev/null)
            if test "$first" = "#!"; then
                echo "patching $fn..."
                sed < "$fn" > "$fn".tmp \
                    -e "s|^#\!\(.*/perl.*\)$|#\! \1$perlFlags|"
                if test -x "$fn"; then chmod +x "$fn".tmp; fi
                mv "$fn".tmp "$fn"
            fi
        fi
    done

    perl Makefile.PL PREFIX=$out $makeMakerFlags
}

postFixup=postFixup
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
