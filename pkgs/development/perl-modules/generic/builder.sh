source $stdenv/setup

PERL5LIB="$PERL5LIB${PERL5LIB:+:}$out/lib/perl5/site_perl"

perlFlags=
for i in $(IFS=:; echo $PERL5LIB); do
    if [[ $i == "$hostperl/lib/perl5/site_perl" ]] || [[ $i == "$hostperl/lib/perl5/site_perl/"* ]]; then
        # exclude paths pointing to perl derivation (like /nix/store/abcdfghijklmnpqrsvwxyz0123456789-perl-5.28.2-aarch64/lib/perl5/site_perl/5.28.2)
        # they are needless when pointing to correct perl, and source of subtle bugs when pointing to wrong perl
        true
    elif [[ $i =~ /[0123456789abcdfghijklmnpqrsvwxyz]{32}-perl-[0-9.]+(-[^/]+)?/lib/perl5/site_perl($|/) ]]; then
        echo -e "unexpected perl $i on PERL5LIB where\n hostperl=$hostperl\n devperl =$devperl\n fullperl=$fullperl"
        exit 1
    elif [[ $perlFlags != *" -I$i"* ]]; then
        perlFlags="$perlFlags -I$i"
    fi
done


oldPreConfigure="$preConfigure"
preConfigure() {

    eval "$oldPreConfigure"

    find . -type f | while read fn; do
        if [[ "$(dd if="$fn" count=2 bs=1 2> /dev/null)" == "#!" ]]; then
            # on `fixupPhase`, `patchShebangsAuto` will replace $devperl/bin/perl with $hostperl/bin/perl
            # for now, a perl working on build platform is required to run tests, etc
            echo "patching shebang of $(pwd)/$fn:"
            echo -n "- "; head -n1 "$fn"
            sed -E "s|^#!\s*(/usr/bin/env\s+)?\S*\bperl\b\S*(.*)$|#!$devperl/bin/perl\2$perlFlags|" -i "$fn"
            echo -n "+ "; head -n1 "$fn"
        fi
    done

    perl Makefile.PL PREFIX=$out INSTALLDIRS=site $makeMakerFlags PERL=$devperl/bin/perl FULLPERL=$fullperl/bin/perl
}


if test -n "$perlPreHook"; then
    eval "$perlPreHook"
fi

genericBuild

if test -n "$perlPostHook"; then
    eval "$perlPostHook"
fi
