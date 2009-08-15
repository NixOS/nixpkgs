source $stdenv/setup

myPatchPhase()
{
    for i in system-config-printer-kde/cmake-modules/FindSystemConfigPrinter.py system-config-printer-kde/system-config-printer-kde.py
    do
	sed -i -e "s|/usr/share/system-config-printer|$system_config_printer/share/system-config-printer|" $i
    done
    
    sed -i -e "s|import cupshelpers.ppds, cupshelpers.cupshelpers|import ppds, cupshelpers|" system-config-printer-kde/cmake-modules/FindSystemConfigPrinter.py
}
patchPhase=myPatchPhase
genericBuild
