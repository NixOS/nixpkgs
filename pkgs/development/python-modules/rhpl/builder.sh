source $stdenv/setup

rpm2cpio $src | cpio -idv
tar xfvj rhpl-*.tar.bz2
rm rhpl-*.tar.bz2
cd rhpl-*
sed -i -e "s@/usr/include/\$(PYTHON)@$python/include/python2.6@" \
       -e "s@PYTHONLIBDIR = /usr/\$(LIBDIR)/\$(PYTHON)/site-packages@PYTHONLIBDIR = $out/lib/python2.6/site-packages@" Makefile.inc
sed -i -e "s@/usr/bin/install@install@g" \
       -e "s@\$(DESTDIR)/usr/share/locale@$out/share/locale@" po/Makefile       
make PREFIX=$out
make PREFIX=$out install
