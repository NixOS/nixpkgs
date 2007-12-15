source ${stdenv}/setup

myPatchPhase()
{
	fixCmakeDbusCalls
	sed -e '/^#define HAS_RANDR_1_2 1$/d' -i ../kcontrol/randr/randr.h
}
patchPhase=myPatchPhase
genericBuild
