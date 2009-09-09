source $stdenv/setup

myPatchPhase()
{
    sed -i -e "s|\${KDE4_DBUS_INTERFACES_DIR}|$out/share/dbus-1|" knotificationitem/CMakeLists.txt
}
patchPhase=myPatchPhase
genericBuild
