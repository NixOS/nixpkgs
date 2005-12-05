set -e
source $stdenv/setup

tar zxvf $src

$jdk/bin/javac java_cup/*.java
$jdk/bin/javac java_cup/runtime/*.java

mkdir -p $out/java_cup/runtime

cp java_cup/*.class $out/java_cup
cp java_cup/runtime/*.class $out/java_cup/runtime/

