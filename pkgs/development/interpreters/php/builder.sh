source $stdenv/setup

alias lex=flex

configureFlags="$configureFlags \
  --with-libxml-dir=$libxml2 \
  --with-apxs2=$apacheHttpd/bin/apxs \
  --with-apr-util=$apacheHttpd"

if test -n "$unixODBC"; then
    configureFlags="$configureFlags --with-unixODBC=$unixODBC"
fi
  
makeFlags="APXS_LIBEXECDIR=$out/modules $makeFlags"
        
genericBuild
