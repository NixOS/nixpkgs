source $stdenv/setup

tar zxvf $src
cd jakarta-regexp-1.4
mkdir -p $out/share/java/
cp jakarta-regexp-1.4.jar $out/share/java/
