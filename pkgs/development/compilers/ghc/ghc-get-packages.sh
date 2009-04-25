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
PKGS=""
for p in $PATH; do
  PkgDir="$p/../lib/ghc-pkgs/ghc-$version"
  for i in $PkgDir/*.installedconf; do
    test -f $i && PKGS="$PKGS $prefix$i"
  done
done
echo $PKGS
