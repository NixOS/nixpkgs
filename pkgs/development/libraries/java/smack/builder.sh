source $stdenv/setup

mkdir smack
cd smack
tar xfvz $src
mkdir -p $out/share/java
cp libs/smack-*.jar $out/share/java
