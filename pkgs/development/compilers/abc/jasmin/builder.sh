source $stdenv/setup

tar zxvf $src  || fail
cd jasmin-*  || fail

sed -e 's/<javac/<javac source="1.4"/' build.xml > build-tmp.xml
mv build-tmp.xml build.xml

cat > ant.settings <<EOF
java_cup.jar=$javaCup

# Location in which to generate Jasmin release tarballs
release.loc=lib

# Version of Jasmin for tagging tarballs
jasmin.version=foo

build.compiler=javac1.4
EOF

ant jasmin-jar || fail

ensureDir $out/jars/ || fail
mv lib/jasminclasses-foo.jar $out/jars/jasmin.jar || fail
