source ${stdenv}/setup

myPatchPhase()
{
	echo "Fixing dbus calls in CMakeLists.txt files"
# Trailing slash in sed is essential
	find .. -name CMakeLists.txt \
	| xargs sed -e "s@\${DBUS_INTERFACES_INSTALL_DIR}/@${kdelibs}/share/dbus-1/interfaces/@" -i
	sed -e '/^#define HAS_RANDR_1_2 1$/d' -i ../kcontrol/randr/randr.h
}
patchPhase=myPatchPhase
genericBuild
