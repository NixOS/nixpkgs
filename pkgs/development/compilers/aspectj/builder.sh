if [ -e "$NIX_ATTRS_SH_FILE" ]; then . "$NIX_ATTRS_SH_FILE"; elif [ -f .attrs.sh ]; then . .attrs.sh; fi
source $stdenv/setup

export JAVA_HOME=$jre

cat >> props <<EOF
output.dir=$out
context.javaPath=$jre
EOF

mkdir -p $out
$jre/bin/java -jar $src -text props

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
