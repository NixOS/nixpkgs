source $stdenv/setup

myPatchPhase()
{
    for i in printer-applet/cmake-modules/FindSystemConfigPrinter.py printer-applet/printer-applet.py
    do
	sed -i -e "s|/usr/share/system-config-printer|$system_config_printer/share/system-config-printer|" $i
    done
    
    sed -i -e "s|import cupshelpers.ppds, cupshelpers.cupshelpers|import ppds, cupshelpers|" printer-applet/cmake-modules/FindSystemConfigPrinter.py
}
patchPhase=myPatchPhase
genericBuild
