source $stdenv/setup

alias lex=flex

configureFlags="$configureFlags \
  --with-libxml-dir=$libxml2 \
  --with-apxs2=$apacheHttpd/bin/apxs \
  --without-libexpat-dir"

if test -n "$unixODBC"; then
    configureFlags="$configureFlags --with-unixODBC=$unixODBC"
fi

if test -n "$postgresql"; then
    configureFlags="$configureFlags --with-pgsql=$postgresql"
fi

if test -n "$mysql"; then
    configureFlags="$configureFlags --with-mysql=$mysql"
fi
  
makeFlags="APXS_LIBEXECDIR=$out/modules $makeFlags"
        
genericBuild
