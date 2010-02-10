source $stdenv/setup

cmakeFlags="-DINSTALL_PATH_GTK_ENGINES=$out/lib/gtk-2.0/2.10.0/engines -DINSTALL_PATH_GTK_THEMES=$out/share/themes -DINSTALL_PATH_KCONTROL_MODULES=$out/lib";

myPatchPhase()
{
    sed -i -e "s|\${KDE4_INCLUDE_DIR}|\${KDE4_INCLUDE_DIR} ../build/kcm_gtk|" kcm_gtk/CMakeLists.txt
    sed -i -e "s|\*.po|../../\*.po|" po/CMakeLists.txt
}
patchPhase=myPatchPhase
genericBuild
