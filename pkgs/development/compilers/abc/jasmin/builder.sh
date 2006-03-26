source $stdenv/setup

tar zxvf $src  || fail
cd jasmin-*  || fail

cat > ant.settings <<EOF
java_cup.jar=$javaCup

# Location in which to generate Jasmin release tarballs
release.loc=lib

# Version of Jasmin for tagging tarballs
jasmin.version=foo
EOF

$apacheAnt/bin/ant jasmin-jar || fail

ensureDir $out/jars/ || fail
mv lib/jasminclasses-foo.jar $out/jars/jasmin.jar || fail
