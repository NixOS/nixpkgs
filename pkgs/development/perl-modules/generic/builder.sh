PERL5LIB="$PERL5LIB${PERL5LIB:+:}$out/lib/perl5/site_perl"

perlFlags=
for i in $(IFS=:; echo $PERL5LIB); do
    perlFlags="$perlFlags -I$i"
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

    local flagsArray=()
    concatTo flagsArray makeMakerFlags

    # Perl expect these to be exported
    export CPPRUN="$CC -E"
    export FULL_AR=$AR
    # Requires to be $CC since it tries adding "-Wl"
    export LD=$CC
    perl Makefile.PL AR="$AR" FULL_AR="$AR" CC="$CC" LD="$CC" CPPRUN="$CPPRUN" \
        PREFIX=$out INSTALLDIRS=site "${flagsArray[@]}" \
        PERL=$(type -P perl) FULLPERL=\"$fullperl/bin/perl\"
}

if test -n "$perlPreHook"; then
    eval "$perlPreHook"
fi

genericBuild

if test -n "$perlPostHook"; then
    eval "$perlPostHook"
fi
