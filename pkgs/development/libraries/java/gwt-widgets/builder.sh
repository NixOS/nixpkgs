source $stdenv/setup

tar xfvz $src
cd gwt-widgets-*
ensureDir $out/share/java
cp gwt-widgets-*.jar $out/share/java
