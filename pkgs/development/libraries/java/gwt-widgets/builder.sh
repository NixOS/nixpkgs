source $stdenv/setup

tar xfvz $src
cd gwt-widgets-*
mkdir -p $out/share/java
cp gwt-widgets-*.jar $out/share/java
