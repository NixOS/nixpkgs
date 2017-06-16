#!/usr/bin/env nix-shell
#!nix-shell -i bash -p busybox unbound

TMP=`mktemp`
unbound-anchor -a $TMP
grep -Ev "^($$|;)" $TMP | sed -e 's/ ;;count=.*//' > root.key
rm $TMP

unbound-anchor -F -a root.ds
