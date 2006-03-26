source $stdenv/setup

ensureDir $out/jars || fail
cp $src $out/jars/$jarname.jar || fail
