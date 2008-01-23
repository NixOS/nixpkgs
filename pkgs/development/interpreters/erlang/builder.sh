buildInputs="$perl $gnum4 $ncurses $openssl"

source $stdenv/setup

tar xfvz $src
cd otp_src_*

# Fix some hard coded paths to /bin/rm
sed -i -e "s|/bin/rm|rm|" lib/odbc/configure
sed -i -e "s|/bin/rm|rm|" erts/configure

./configure --prefix=$out --with-ssl=$openssl
make
make install
