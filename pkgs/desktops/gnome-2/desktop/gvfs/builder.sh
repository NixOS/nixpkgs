source $stdenv/setup

myPatchPhase()
{
    sed -i -e "/giomodulesdir=/ agiomodulesdir=$out/lib/gio" configure
}

patchPhase=myPatchPhase
genericBuild
