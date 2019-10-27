# See pkgs/build-support/setup-hooks/role.bash
getHostRole

export NIX_${role_pre}CXXSTDLIB_COMPILE+=" -isystem $(echo -n @gcc@/include/c++/*) -isystem $(echo -n @gcc@/include/c++/*)/$(@gcc@/bin/gcc -dumpmachine)"
