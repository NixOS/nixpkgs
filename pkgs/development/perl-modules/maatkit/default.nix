{buildPerlPackage, stdenv, fetchurl, DBDmysql}:

buildPerlPackage rec {
  name = "maatkit-4790";

  src = fetchurl {
    url = "http://maatkit.googlecode.com/files/${name}.tar.gz" ;
    sha256 = "0lf6dgh1w96m234hrkhagyyvv1m1ldchpzsg6iswvkj6sbvv7d7h";
  };

  buildInputs = [ DBDmysql ] ;

  preConfigure = ''
    find . | while read fn; do
        if test -f "$fn"; then
            first=$(dd if="$fn" count=2 bs=1 2> /dev/null)
            if test "$first" = "#!"; then
                sed < "$fn" > "$fn".tmp \
                    -e "s|^#\!\(.*[/\ ]perl.*\)$|#\!$perl/bin/perl $perlFlags|"
                if test -x "$fn"; then chmod +x "$fn".tmp; fi
                mv "$fn".tmp "$fn"
            fi
        fi
    done
  '' ;

  meta = {
    description = "Maatkit makes MySQL easier and safer to manage. It provides simple, predictable ways to do things you cannot otherwise do.";
    license = "GPLv2+";
    homepage = http://www.maatkit.org/;
  };
}
