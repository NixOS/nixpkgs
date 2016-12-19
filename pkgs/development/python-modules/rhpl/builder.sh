source $stdenv/setup

rpmextract $src
tar xfvj rhpl-*.tar.bz2
rm rhpl-*.tar.bz2
cd rhpl-*
incl=$(echo $python/include/python2.*)
sed -i -e "s@/usr/include/\$(PYTHON)@$incl@" \
       -e "s@PYTHONLIBDIR = /usr/\$(LIBDIR)/\$(PYTHON)/site-packages@PYTHONLIBDIR = $(toPythonPath $out)@" Makefile.inc
sed -i -e "s@/usr/bin/install@install@g" \
       -e "s@\$(DESTDIR)/usr/share/locale@$out/share/locale@" po/Makefile       
make PREFIX=$out
make PREFIX=$out install
