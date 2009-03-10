source $stdenv/setup

myPatchPhase()
{
    sed -i -e "s|\${SVN_INCLUDES}|\${SVN_INCLUDES} $aprutil/include/apr-1|" kioslave/svn/CMakeLists.txt
}
patchPhase=myPatchPhase
genericBuild
