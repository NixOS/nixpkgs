export NIX_CXXSTDLIB_COMPILE+=" -isystem $(echo -n @gcc@/include/c++/*) -isystem $(echo -n @gcc@/include/c++/*)/$(@gcc@/bin/gcc -dumpmachine)"
export NIX_CXXSTDLIB_LINK=" -stdlib=libstdc++"
