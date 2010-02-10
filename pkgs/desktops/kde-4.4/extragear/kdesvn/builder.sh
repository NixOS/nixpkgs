source $stdenv/setup

myPatchPhase()
{
    sed -i -e "s|/usr|$subversion|g" src/svnqt/cmakemodules/FindSubversion.cmake
}
patchPhase=myPatchPhase
genericBuild
