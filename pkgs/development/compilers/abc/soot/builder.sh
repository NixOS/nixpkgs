source $stdenv/setup

tar zxvf $src
cd soot-*

export NIX_ANT_OPTS="$ANT_OPTS -Xmx200m"

cat > ant.settings <<EOF
polyglot.jar=$polyglot/jars/polyglot.jar
jasmin.jar=$jasmin/jars/jasmin.jar
soot.version=foo
release.loc=lib
javaapi.url=http://java.sun.com/j2se/1.4.2/docs/api/
EOF

ant classesjar

mkdir -p $out/jars/
mv lib/sootclasses-foo.jar $out/jars/soot.jar
