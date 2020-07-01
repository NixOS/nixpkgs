# See pkgs/build-support/setup-hooks/role.bash
getHostRole

linkCxxAbi="@linkCxxAbi@"
export NIX_CXXSTDLIB_COMPILE${role_post}+=" -isystem @out@/include/c++/v1"
export NIX_CXXSTDLIB_LINK${role_post}=" -stdlib=libc++${linkCxxAbi:+" -lc++abi"}"
