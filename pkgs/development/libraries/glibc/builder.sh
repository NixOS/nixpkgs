# glibc cannot have itself in its rpath.
export NIX_NO_SELF_RPATH=1
export NIX_DONT_SET_RPATH=1

source $stdenv/setup
source $substitute

# Explicitly tell glibc to use our pwd, not /bin/pwd.
export PWD_P=$(type -tP pwd)


postUnpack=postUnpack
postUnpack() {
    cd $sourceRoot
    unpackFile $linuxthreadsSrc
    cd ..
}


preConfigure=preConfigure
preConfigure() {

    # Use Linuxthreads instead of NPTL.
    rm -rf nptl

    for i in configure io/ftwtest-sh; do
        substituteInPlace "$i" \
            --replace "@PWD@" "pwd"
    done

    mkdir ../build
    cd ../build
    
    configureScript=../$sourceRoot/configure
}


postInstall=postInstall
postInstall() {
    if test -n "$installLocales"; then
        make localedata/install-locales
    fi
    rm $out/etc/ld.so.cache
    (cd $out/include && ln -s $kernelHeaders/include/* .) || exit 1
}


genericBuild
