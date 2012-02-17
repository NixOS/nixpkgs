# Glibc cannot have itself in its RPATH.
export NIX_NO_SELF_RPATH=1

source $stdenv/setup

# Explicitly tell glibc to use our pwd, not /bin/pwd.
export PWD_P=$(type -tP pwd)

# Needed to install share/zoneinfo/zone.tab.  Set to impure /bin/sh to
# prevent a retained dependency on the bootstrap tools in the
# stdenv-linux bootstrap.
export BASH_SHELL=/bin/sh


preConfigure() {

    for i in configure io/ftwtest-sh; do
        # Can't use substituteInPlace here because replace hasn't been
        # built yet in the bootstrap.
        sed -i "$i" -e "s^/bin/pwd^$PWD_P^g"
    done

    # In the glibc 2.6/2.7 tarballs C-translit.h is a little bit older
    # than C-translit.h.in, forcing Make to rebuild it unnecessarily.
    # This wouldn't be problem except that it requires Perl, which we
    # don't want as a dependency in the Nixpkgs bootstrap.  So force
    # the output file to be newer.
    touch locale/C-translit.h

    tar xvjf "$srcPorts"
    
    mkdir build
    cd build
    
    configureScript=../configure
}

genericBuild
