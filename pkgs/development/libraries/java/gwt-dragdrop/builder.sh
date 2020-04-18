source $stdenv/setup

mkdir -p $out/share/java
cp $src $out/share/java/$name.jar
