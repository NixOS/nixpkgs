source $stdenv/setup

tar zxvf $src
cd jakarta-regexp-1.3
mkdir -p $out/share/java/
cp jakarta-regexp-1.3.jar $out/share/java/
