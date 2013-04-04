#! /bin/sh
# Usage:
#  $1: version of GHC
#  $2: invocation path of GHC
#  $3: prefix
version="$1"
if test -z "$3"; then
  prefix="-package-conf "
else
  prefix="$3"
fi
PATH="$2:$PATH"
IFS=":"
for p in $PATH; do
  PkgDir="$p/../lib/ghc-$version/package.conf.d"
  for i in $PkgDir/*.installedconf; do
    # output takes place here
    test -f $i && echo -n " $prefix$i"
  done
done
test -f "$2/../lib/ghc-$version/package.conf" && echo -n " $prefix$2/../lib/ghc-$version/package.conf"
