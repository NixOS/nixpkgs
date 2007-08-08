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
	echo "Fixing dbus calls in CMakeLists.txt files"
# Trailing slash in sed is essential
	find .. -name CMakeLists.txt \
	| xargs sed -e "s@\${DBUS_INTERFACES_INSTALL_DIR}/@${kdelibs}/share/dbus-1/interfaces/@" -i
	sed -e '/^#define HAS_RANDR_1_2 1$/d' -i ../workspace/kcontrol/randr/randr.h
}
patchPhase=myPatchPhase
genericBuild
