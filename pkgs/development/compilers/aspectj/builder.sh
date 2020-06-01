source $stdenv/setup

export JAVA_HOME=$jre8

cat >> props <<EOF
output.dir=$out
context.javaPath=$jre8
EOF

mkdir -p $out
$jre8/bin/java -jar $src -text props

echo "Removing files at top level"
for file in $out/*
do
  if test -f $file ; then
    rm $file
  fi
done

cat >> $out/bin/aj-runtime-env <<EOF
#! $SHELL

export CLASSPATH=$CLASSPATH:.:$out/lib/aspectjrt.jar
EOF

chmod u+x $out/bin/aj-runtime-env
