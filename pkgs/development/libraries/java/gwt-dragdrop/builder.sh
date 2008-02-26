source $stdenv/setup

ensureDir $out/share/java
cp $src $out/share/java/$name.jar
