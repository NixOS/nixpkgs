source $stdenv/setup

tar xfvj $src
cd kdebindings-*/python/pykde4
python configure.py -d $out/lib/python2.5/site-packages -v $out/share/sip
for i in `find . -name Makefile`
do
    sed -i -e "s/-O2/-O0/" $i
done
make
make install
