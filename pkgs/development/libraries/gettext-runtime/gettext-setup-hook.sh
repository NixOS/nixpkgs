# libintl must be listed in load flags on non-Glibc
# it doesn't hurt to have it in Glibc either though
if [ -n "@gettextNeedsLdflags@" -a -z "${dontAddExtraLibs-}" ]; then
    # See pkgs/build-support/setup-hooks/role.bash
    getHostRole
    export NIX_${role_pre}LDFLAGS+=" -lintl"
fi
