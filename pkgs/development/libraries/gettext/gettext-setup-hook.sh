gettextDataDirsHook() {
    if [ -d "$1/share/gettext" ]; then
        addToSearchPath GETTEXTDATADIRS "$1/share/gettext"
    fi
}

addEnvHooks "$hostOffset" gettextDataDirsHook

# libintl must be listed in load flags on non-Glibc
# it doesn't hurt to have it in Glibc either though
gettextLdflags() {
    # The `depHostOffset` describes how the host platform of the dependencies
    # are slid relative to the depending package. It is brought into scope of
    # the environment hook defined as the role of the dependency being applied.
    case $depHostOffset in
        -1) local role='BUILD_' ;;
        0)  local role='' ;;
        1)  local role='TARGET_' ;;
        *)  echo "cc-wrapper: Error: Cannot be used with $depHostOffset-offset deps" >2;
            return 1 ;;
    esac

    export NIX_${role}LDFLAGS+=" -lintl"
}

if [ ! -z "@gettextNeedsLdflags@" ]; then
    addEnvHooks "$hostOffset" gettextLdflags
fi
