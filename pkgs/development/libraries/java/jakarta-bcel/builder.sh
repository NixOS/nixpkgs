source $stdenv/setup

tar zxvf $src
cd bcel-5.1
mkdir -p $out/share/java/
cp bcel-5.1.jar $out/share/java/
