. $stdenv/setup

echo "pwd = `pwd`"
echo "PATH = $PATH"

echo "ACLOCAL_PATH = $ACLOCAL_PATH"

cp -r $src strategoxt
chmod -R +w strategoxt
cd strategoxt
./bootstrap
./configure --prefix=$out --with-aterm=$aterm --with-sdf=$sdf
make install
