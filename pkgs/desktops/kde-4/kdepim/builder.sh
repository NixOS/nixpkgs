source ${stdenv}/setup

myPreBuild()
{
	for i in ${qt}/include/*; do
		NIX_CFLAGS_COMPILE="-I$i ${NIX_CFLAGS_COMPILE}"
	done;
	echo "${NIX_CFLAGS_COMPILE}"
}
preBuild=myPreBuild

myPatchPhase()
{
	sed -e '3s/)/ ${CMAKE_MODULE_PATH})/' -i ../CMakeLists.txt
}
patchPhase=myPatchPhase

genericBuild
