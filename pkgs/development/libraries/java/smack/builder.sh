source $stdenv/setup

tar xfvz $src
cd smack*
ensureDir $out/share/java
cp *.jar $out/share/java
