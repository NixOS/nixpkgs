# Nowadays lrelease feature in mkspecs of qtbase can automatically find the tool in PATH with qtPrepareTool
# and process TRANSLATIONS if the pro file has CONFIG+=lrelease in it.
# But for some reason QMAKE_LRELEASE from qtPrepareTool does not propagate to the pro file itself, and some
# packages still use QMAKE_LRELEASE directly, so we'll need to pass it explicitly until there's a better
# mkspecs based solution.
# NB: this could be non-overridable via qmakeFlags attribute in a package due to hook ordering.

if [[ -z "${__nix_qttoolsHook-}" ]]; then
    __nix_qttoolsHook=1  # Don't run this hook more than once.

    if ! appendToVar qmakeFlags "QMAKE_LRELEASE=$(PATH="$_PATH" command -v lrelease)" ; then
        echo "FYI: can't find a runnable lrelease in PATH. If this package doesn't use it than it's perfectly fine."
        echo "Otherwise you should add qttools to nativeBuildInputs."
    fi
fi
