. $stdenv/setup

tar jxvf $src
mkdir $out
mkdir $out/include

cd STLport
cp -prv stlport $out/include
