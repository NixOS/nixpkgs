source $stdenv/setup

configureFlags="--with-zlib=$zlib"
if test "$pythonSupport"; then
    configureFlags="--with-python=$python $configureFlags"
fi

patchPhase() {
    echo "Patching"
    mv configure configure.old
    sed -e "s^pythondir=.*$^pythondir=$out/lib/python2.4/site-packages^" < configure.old > configure
    chmod u+x configure
}
patchPhase=patchPhase

genericBuild
