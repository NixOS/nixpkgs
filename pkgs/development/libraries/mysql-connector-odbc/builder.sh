source $stdenv/setup

configureFlags="$configureFlags \
  --with-mysql-path=$mysql \
  --with-unixODBC=$unixODBC"

genericBuild