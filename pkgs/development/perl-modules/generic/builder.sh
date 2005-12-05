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

if test -n "$perlPreHook"; then
    source $perlPreHook
fi

genericBuild

if test -n "$perlPostHook"; then
    source $perlPostHook
fi
