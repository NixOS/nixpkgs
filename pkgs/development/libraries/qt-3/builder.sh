. $stdenv/setup


preConfigure=preConfigure
preConfigure() {

    # Patch some of the configure files a bit to get of global paths.
    # (Buildings using stuff in those paths will fail anyway, but it
    # will cause ./configure misdetections).
    for i in config.tests/*/*.test mkspecs/*/qmake.conf; do
        echo "patching $i..."
        sed < $i > $i.tmp \
            -e 's^ /lib^ /FOO^g' \
            -e 's^/usr^/FOO^g'
        mv $i.tmp $i
    done

    chmod +x config.tests/*/*.test
}


# !!! TODO: -system-libmng
configureFlags="-v -prefix $out -system-zlib -system-libpng -system-libjpeg"
dontAddPrefix=1

if test -n "$threadSupport"; then
    configureFlags="-thread";
else    
    configureFlags="-no-thread";
fi

if test -n "$xftSupport"; then
    configureFlags="-xft -L$libXft/lib -I$libXft/include \
      -L$freetype/lib -I$freetype/include \
      -L$fontconfig/lib -I$fontconfig/include \
      $configureFlags"
fi

if test -n "$xrenderSupport"; then
    configureFlags="-xrender -L$libXrender/lib -I$libXrender/include $configureFlags"
fi

configureScript=configureScript
configureScript() {
    echo yes | ./configure $configureFlags
    export LD_LIBRARY_PATH=$(pwd)/lib
}


postInstall=postInstall
postInstall() {
    # Qt's `make install' is broken; it copies ./bin/qmake, which
    # is a symlink to ./qmake/qmake.  So we end up with a dangling
    # symlink.
    rm $out/bin/qmake
    cp -p qmake/qmake $out/bin
}


genericBuild
