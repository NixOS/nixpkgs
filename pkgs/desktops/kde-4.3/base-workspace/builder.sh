source $stdenv/setup

myPatchPhase()
{
    for i in plasma/applets/systemtray/CMakeLists.txt plasma/applets/systemtray/notificationitemwatcher/CMakeLists.txt
    do
        sed -i -e "s|\${KDE4_DBUS_INTERFACES_DIR}|$kdelibs_experimental/share/dbus-1|" $i
    done
}
patchPhase=myPatchPhase
genericBuild
