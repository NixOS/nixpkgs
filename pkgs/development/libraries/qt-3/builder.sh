source $stdenv/setup


preConfigure() {

    # Patch some of the configure files a bit to get of global paths.
    # (Buildings using stuff in those paths will fail anyway, but it
    # will cause ./configure misdetections).
    for i in config.tests/unix/checkavail config.tests/*/*.test mkspecs/*/qmake.conf; do
        echo "patching $i..."
        substituteInPlace "$i" \
            --replace " /lib" " /FOO" \
            --replace "/usr" "/FOO"
    done
}


# !!! TODO: -system-libmng
configureFlags="-prefix $out $configureFlags"
dontAddPrefix=1

configureScript=configureScript
configureScript() {
    echo yes | ./configure $configureFlags
    export LD_LIBRARY_PATH=$(pwd)/lib
}


postInstall() {
    # Qt's `make install' is broken; it copies ./bin/qmake, which
    # is a symlink to ./qmake/qmake.  So we end up with a dangling
    # symlink.
    rm $out/bin/qmake
    cp -p qmake/qmake $out/bin
}


genericBuild
