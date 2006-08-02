source $stdenv/setup

tar zxvf $src  || fail
cd polyglot-*  || fail

ant polyglot-jar || fail
ant cup || fail

ensureDir $out/jars/ || fail
mv lib/java_cup.jar $out/jars/ || fail
mv lib/polyglot*.jar $out/jars/ || fail
