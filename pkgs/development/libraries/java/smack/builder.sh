source $stdenv/setup

tar xfvz $src
cd smack*
mkdir -p $out/share/java
cp *.jar $out/share/java
