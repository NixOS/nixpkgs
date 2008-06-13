source $stdenv/setup

tar zxvf $src
cd polyglot-*

ant polyglot-jar
ant cup

ensureDir $out/jars/
mv lib/java_cup.jar $out/jars/
mv lib/polyglot*.jar $out/jars/
