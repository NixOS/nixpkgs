# libiconv must be listed in load flags on non-Glibc
# it doesn't hurt to have it in Glibc either though

# See pkgs/build-support/setup-hooks/role.bash
if [ -z "${dontAddExtraLibs-}" ]; then
    getHostRole
    export NIX_LDFLAGS${role_post}+=" -liconv"
fi
