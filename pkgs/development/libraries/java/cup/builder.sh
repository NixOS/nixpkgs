set -e
. $stdenv/setup

tar zxvf $src

$j2sdk/bin/javac java_cup/*.java
$j2sdk/bin/javac java_cup/runtime/*.java

mkdir -p $out/java_cup/runtime

cp java_cup/*.class $out/java_cup
cp java_cup/runtime/*.class $out/java_cup/runtime/

