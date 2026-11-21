# This build script is largely based on the following MIT-licensed works:
# https://github.com/lukaslaobeyer/nix-fpgapkgs
# Copyright (c) 2020 Lukas Lao Beyer
# https://github.com/lschuermann/nur-packages
# Copyright (c) 2021-2025 Leon Schuermann <leon@is.currently.online>

source $stdenv/setup

echo "Running Xilinx Vivado installer..."

mkdir -p $out/opt

export LD_LIBRARY_PATH="$LD_LIBRARY_PATH:${libPath}"

cat > install_config.txt <<EOF
#### Vivado ML Standard Install Configuration ####
Edition=Vivado ML Standard

Product=Vivado

# Path where Xilinx software will be installed.
Destination=$out/opt

# Choose the Products/Devices the you would like to install.
Modules=$devices

# Choose the post install scripts you'd like to run as part of the finalization step. Please note that some of these scripts may require user interaction during runtime.
InstallOptions=

## Shortcuts and File associations ##
# Choose whether Start menu/Application menu shortcuts will be created or not.
CreateProgramGroupShortcuts=0

# Choose the name of the Start menu/Application menu shortcut. This setting will be ignored if you choose NOT to create shortcuts.
ProgramGroupFolder=Xilinx Design Tools

# Choose whether shortcuts will be created for All users or just the Current user. Shortcuts can be created for all users only if you run the installer as administrator.
CreateShortcutsForAllUsers=0

# Choose whether shortcuts will be created on the desktop or not.
CreateDesktopShortcuts=0

# Choose whether file associations will be created or not.
CreateFileAssociation=0

# Choose whether disk usage will be optimized (reduced) after installation
EnableDiskUsageOptimization=1
EOF

# The installer will be killed as soon as it says that post install
# tasks have failed.  This is required because it tries to run the
# unpatched scripts to check if the installation has
# succeeded. However, these scripts will fail because they have not
# been patched yet, and the installer will proceed to delete the
# installation if not killed.
($extracted/xsetup --agree XilinxEULA,3rdPartyEULA --batch Install --config install_config.txt || true) | while read line
do
    [[ "${line}" == *"Execution of Pre/Post Installation Tasks Failed"* ]] && echo "killing installer!" && ((pkill -9 -f "$extracted/$builtinJavaBin") || true)
    echo ${line}
done


# Patch installed files
patchShebangs $out/opt/$version/Vivado/bin
echo "Shebangs patched"

autoPatchelf "$out/opt/$version/Vivado/bin/unwrapped/lnx64.o"

patchelf --set-interpreter "$(cat $NIX_CC/nix-support/dynamic-linker)" $out/opt/$version/Vivado/tps/lnx64/jre21.0.5_11/bin/java

echo "ELFs patched"

wrapProgram $out/opt/$version/Vivado/bin/vivado --prefix LD_LIBRARY_PATH : "$libPath"
wrapProgram $out/opt/$version/Vivado/$builtinJavaBin --prefix LD_LIBRARY_PATH : "$libPath"

# wrapProgram on its own will not work because of the way the Vivado
# script runs ./launch. Therefore, we need even more patches...
sed -i -- 's|`basename "\$0"`|vivado|g' $out/opt/$version/Vivado/bin/.vivado-wrapped
sed -i -- 's|/bin/touch|/usr/bin/env touch|g' $out/opt/$version/Vivado/scripts/ISEWrap.sh

# Add Vivado to bin folder
mkdir $out/bin
ln -s $out/opt/$version/Vivado/bin/vivado $out/bin/vivado

