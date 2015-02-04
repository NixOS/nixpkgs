export NIX_CFLAGS_COMPILE+=" -isystem @out@/include/c++/v1 -stdlib=libc++"
export NIX_CFLAGS_LINK+=" -stdlib=libc++ -Wl,-rpath,@libcxxabi@/lib"
