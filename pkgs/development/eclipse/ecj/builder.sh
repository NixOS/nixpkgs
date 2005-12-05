source $stdenv/setup

unzip $src
cd jdtcoresrc
ant -f compilejdtcorewithjavac.xml

mkdir -p $out/share/ecj
mv ecj.jar $out/share/ecj

mkdir -p $out/bin

cat >> $out/bin/ecj <<EOF
#! /bin/sh

export JAVA_HOME=$jre
export LANG="en_US"

$jre/bin/java -cp $out/share/ecj/ecj.jar org.eclipse.jdt.internal.compiler.batch.Main \$@
EOF

chmod u+x $out/bin/ecj
