. $stdenv/setup

alias lex=flex

configureFlags="--with-libxml-dir=$libxml2 --with-apxs2=$apacheHttpd/bin/apxs --with-apr-util=$apacheHttpd"
makeFlags="APXS_LIBEXECDIR=$out/modules $makeFlags"
        
genericBuild
