source $stdenv/setup

ensureDir $out/jars
cp $src $out/jars/$jarname.jar
