if [ -e "$NIX_ATTRS_SH_FILE" ]; then . "$NIX_ATTRS_SH_FILE"; elif [ -f .attrs.sh ]; then . .attrs.sh; fi
source $stdenv/setup

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

    perl Makefile.PL PREFIX=$out INSTALLDIRS=site "${flagsArray[@]}" PERL=$(type -P perl) FULLPERL=\"$fullperl/bin/perl\"
}

if test -n "$perlPreHook"; then
    eval "$perlPreHook"
fi

genericBuild

if test -n "$perlPostHook"; then
    eval "$perlPostHook"
fi
