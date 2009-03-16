source $stdenv/setup

myPatchPhase()
{
    find .. -name CMakeLists.txt | xargs sed -i -e "s@DESTINATION \${KDE4_DBUS_INTERFACES_DIR}@DESTINATION \${CMAKE_INSTALL_PREFIX}/share/dbus-1/interfaces/@"
}
patchPhase=myPatchPhase
genericBuild
