# See pkgs/build-support/setup-hooks/role.bash
getHostRole

export NIX_CXXSTDLIB_COMPILE${role_post}+=" -isystem $(echo -n @gcc@/include/c++/*) -isystem $(echo -n @gcc@/include/c++/*)/@targetConfig@"
