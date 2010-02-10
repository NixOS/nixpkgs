source $stdenv/setup

myPatchPhase()
{
    sed -i -e "s@\${DBUS_INTERFACES_INSTALL_DIR}@\$ENV{kdebase_workspace}/share/dbus-1/interfaces@" applets/lancelot/app/src/CMakeLists.txt
}

patchPhase=myPatchPhase
genericBuild
