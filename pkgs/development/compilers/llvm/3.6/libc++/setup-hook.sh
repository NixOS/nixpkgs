export NIX_CFLAGS_COMPILE+=" -isystem @out@/include/c++/v1"

export NIX_CXXSTDLIB_COMPILE=" -stdlib=libc++"
export NIX_CXXSTDLIB_LINK=" -stdlib=libc++"
