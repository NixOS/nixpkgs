source $stdenv/setup

# This must be the ugliest builder in the Nix Packages

tar zxvf $nsssrc
tar zxvf $nsprsrc

mv nspr-*/mozilla/nsprpub nss-*/mozilla
cd nss-*/mozilla/security/nss
make nss_build_all
make install

mkdir -p $out/lib
mkdir -p $out/include/nspr
find ../../dist/*/lib -type l -name "*.so" -o -name "*.chk" | xargs --replace cp -L {} $out/lib
cp -Lr ../../dist/public/* $out/include
cp -Lr ../../dist/*/include/* $out/include/nspr
