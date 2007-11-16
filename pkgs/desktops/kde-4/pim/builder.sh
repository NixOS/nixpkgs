source ${stdenv}/setup

myPatchPhase()
{
# They reset CMAKE_MODULE_PATH, not adding to the existing
	sed -e '3s/)/ ${CMAKE_MODULE_PATH})/' -i ../CMakeLists.txt
}
patchPhase=myPatchPhase

genericBuild
