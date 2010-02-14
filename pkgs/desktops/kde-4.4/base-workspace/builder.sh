source $stdenv/setup

myPatchPhase()
{
    sed -i -e "s|\${PYTHON_SITE_PACKAGES_DIR}|$out/lib/python2.6/site-packages|" plasma/generic/scriptengines/python/CMakeLists.txt
}
patchPhase=myPatchPhase
genericBuild
