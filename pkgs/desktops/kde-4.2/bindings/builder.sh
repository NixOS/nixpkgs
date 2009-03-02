source $stdenv/setup

myPatchPhase()
{
    # Fix python site packages directory
    sed -i -e "s@\${PYTHON_SITE_PACKAGES_DIR}@\${CMAKE_INSTALL_PREFIX}/lib/python2.5@g" \
           -e "s@\${SIP_DEFAULT_SIP_DIR}@\${CMAKE_INSTALL_PREFIX}/share/sip@g" \
	   python/pykde4/CMakeLists.txt
}
patchPhase=myPatchPhase
genericBuild
