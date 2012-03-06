source $stdenv/setup

tar zxvf $src

cd abc-*

for p in $patches; do
  echo "applying patch $p"
  patch -p1 < $p
done

cat > ant.settings <<EOF
polyglot.loc=$polyglot/jars/polyglot.jar
polyglot.cupclasses.loc=$polyglot/jars/java_cup.jar
jflex.loc=
soot.loc=$soot/jars/soot.jar
jasmin.loc=$jasmin/jars/jasmin.jar
xact.loc=$xact/jars/xact.jar
paddle.loc=$paddle/jars/paddle.jar
jedd.runtime.jar=$jedd/jars/jedd.runtime.jar
javabdd.jar=$javabdd/jars/javabdd.jar
EOF

$apacheAnt/bin/ant jars

mkdir -p $out/jars

cp lib/abc.jar $out/jars
cp lib/abc-runtime.jar $out/jars
cp lib/abc-testing.jar $out/jars
cp lib/abc-complete.jar $out/jars

# Create the executable abc script
mkdir -p $out/bin
cat > $out/bin/abc <<EOF
#! $SHELL -e

exec $jre/bin/java -classpath $out/jars/abc-complete.jar -Xmx256M -Dabc.home=$out/jars abc.main.Main \$@
EOF
chmod +x $out/bin/abc
