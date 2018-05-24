# See pkgs/build-support/setup-hooks/role.bash
getHostRole

linkCxxAbi="@linkCxxAbi@"
export NIX_${role_pre}CXXSTDLIB_COMPILE+=" -isystem @out@/include/c++/v1"
export NIX_${role_pre}CXXSTDLIB_LINK=" -stdlib=libc++${linkCxxAbi:+" -lc++abi"}"
