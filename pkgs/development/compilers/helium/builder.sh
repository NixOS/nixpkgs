buildinputs="$ghc"
. $stdenv/setup || exit 1

tar xvfz $src || exit 1
cd helium-* || exit 1
cd lvm/src || exit 1
./configure --prefix $out || exit 1
cd ../../heliumNT || exit 1
./configure --prefix=$out || exit 1
cd src || exit 1
make depend || exit 1
make EXTRA_HC_OPTS=-O2 || exit 1
make install
