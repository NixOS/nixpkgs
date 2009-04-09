source $stdenv/setup

myPatchPhase()
{
    sed -i -e "s|/usr|$loudmouth|g" cmake/modules/FindLoudmouth.cmake
    sed -i -e "s|/usr|$mysql|g" cmake/modules/FindMySQLAmarok.cmake
}
patchPhase=myPatchPhase
genericBuild
