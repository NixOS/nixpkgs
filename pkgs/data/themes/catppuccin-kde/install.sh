COLORDIR=$out/share/color-schemes
AURORAEDIR=$out/share/aurorae/themes
LOOKANDFEELDIR=$out/share/plasma/look-and-feel
DESKTOPTHEMEDIR=$out/share/plasma/desktoptheme

FLAVOUR=${FLAVOUR^}
ACCENT=${ACCENT^}
WINDECSTYLE=${WINDECSTYLE^}

echo "Creating theme directories.."
mkdir -p $COLORDIR
mkdir -p $AURORAEDIR
mkdir -p $LOOKANDFEELDIR
mkdir -p $DESKTOPTHEMEDIR
mkdir ./dist

# Sets accent based on the pallet selected (Best to fold this in your respective editor)
if [[ $ACCENT == "Rosewater" ]]; then
    if [[ $FLAVOUR == "Mocha" ]]; then
        ACCENTCOLOR=#f5e0dc
    elif [[ $FLAVOUR == "Macchiato" ]]; then
        ACCENTCOLOR=#f4dbd6
    elif [[ $FLAVOUR == "Frappe" ]]; then
        ACCENTCOLOR=#f2d5cf
    elif [[ $FLAVOUR == "Latte" ]]; then
        ACCENTCOLOR=#dc8a78
    fi
    echo "Accent Rosewater(1) was selected!"
elif [[ $ACCENT == "Flamingo" ]]; then
    if [[ $FLAVOUR == "Mocha" ]]; then
        ACCENTCOLOR=#f2cdcd
    elif [[ $FLAVOUR == "Macchiato" ]]; then
        ACCENTCOLOR=#f0c6c6
    elif [[ $FLAVOUR == "Frappe" ]]; then
        ACCENTCOLOR=#eebebe
    elif [[ $FLAVOUR == "Latte" ]]; then
        ACCENTCOLOR=#dd7878
    fi
    echo "Accent Flamingo(2) was selected!"
    ACCENT="2"
elif [[ $ACCENT == "Pink" ]]; then
    if [[ $FLAVOUR == "Mocha" ]]; then
        ACCENTCOLOR=#f5c2e7
    elif [[ $FLAVOUR == "Macchiato" ]]; then
        ACCENTCOLOR=#f5bde6
    elif [[ $FLAVOUR == "Frappe" ]]; then
        ACCENTCOLOR=#f4b8e4
    elif [[ $FLAVOUR == "Latte" ]]; then
        ACCENTCOLOR=#ea76cb
    fi
    echo "Accent Pink(3) was selected!"
elif [[ $ACCENT == "Mauve" ]]; then
    if [[ $FLAVOUR == "Mocha" ]]; then
        ACCENTCOLOR=#cba6f7
    elif [[ $FLAVOUR == "Macchiato" ]]; then
        ACCENTCOLOR=#c6a0f6
    elif [[ $FLAVOUR == "Frappe" ]]; then
        ACCENTCOLOR=#ca9ee6
    elif [[ $FLAVOUR == "Latte" ]]; then
        ACCENTCOLOR=#8839ef
    fi
    echo "Accent Mauve(4) was selected!"
elif [[ $ACCENT == "Red" ]]; then
    if [[ $FLAVOUR == "Mocha" ]]; then
        ACCENTCOLOR=#f38ba8
    elif [[ $FLAVOUR == "Macchiato" ]]; then
        ACCENTCOLOR=#ed8796
    elif [[ $FLAVOUR == "Frappe" ]]; then
        ACCENTCOLOR=#e78284
    elif [[ $FLAVOUR == "Latte" ]]; then
        ACCENTCOLOR=#d20f39
    fi
    echo "Accent Red(5) was selected!"
elif [[ $ACCENT == "Maroon" ]]; then
    if [[ $FLAVOUR == "Mocha" ]]; then
        ACCENTCOLOR=#eba0ac
    elif [[ $FLAVOUR == "Macchiato" ]]; then
        ACCENTCOLOR=#ee99a0
    elif [[ $FLAVOUR == "Frappe" ]]; then
        ACCENTCOLOR=#ea999c
    elif [[ $FLAVOUR == "Latte" ]]; then
        ACCENTCOLOR=#e64553
    fi
    echo "Accent Maroon(6) was selected!"
elif [[ $ACCENT == "Peach" ]]; then
    if [[ $FLAVOUR == "Mocha" ]]; then
        ACCENTCOLOR=#fab387
    elif [[ $FLAVOUR == "Macchiato" ]]; then
        ACCENTCOLOR=#f5a97f
    elif [[ $FLAVOUR == "Frappe" ]]; then
        ACCENTCOLOR=#ef9f76
    elif [[ $FLAVOUR == "Latte" ]]; then
        ACCENTCOLOR=#fe640b
    fi
    echo "Accent Peach(7) was selected!"
elif [[ $ACCENT == "Yellow" ]]; then
    if [[ $FLAVOUR == "Mocha" ]]; then
        ACCENTCOLOR=#f9e2af
    elif [[ $FLAVOUR == "Macchiato" ]]; then
        ACCENTCOLOR=#eed49f
    elif [[ $FLAVOUR == "Frappe" ]]; then
        ACCENTCOLOR=#e5c890
    elif [[ $FLAVOUR == "Latte" ]]; then
        ACCENTCOLOR=#df8e1d
    fi
    echo "Accent Yellow(8) was selected!"
elif [[ $ACCENT == "Green" ]]; then
    if [[ $FLAVOUR == "Mocha" ]]; then
        ACCENTCOLOR=#a6e3a1
    elif [[ $FLAVOUR == "Macchiato" ]]; then
        ACCENTCOLOR=#a6da95
    elif [[ $FLAVOUR == "Frappe" ]]; then
        ACCENTCOLOR=#a6d189
    elif [[ $FLAVOUR == "Latte" ]]; then
        ACCENTCOLOR=#40a02b
    fi
    echo "Accent Green(9) was selected!"
elif [[ $ACCENT == "Teal" ]]; then
    if [[ $FLAVOUR == "Mocha" ]]; then
        ACCENTCOLOR=#94e2d5
    elif [[ $FLAVOUR == "Macchiato" ]]; then
        ACCENTCOLOR=#8bd5ca
    elif [[ $FLAVOUR == "Frappe" ]]; then
        ACCENTCOLOR=#81c8be
    elif [[ $FLAVOUR == "Latte" ]]; then
        ACCENTCOLOR=#179299
    fi
    echo "Accent Teal(10) was selected!"
elif [[ $ACCENT == "Sky" ]]; then
    if [[ $FLAVOUR == "Mocha" ]]; then
        ACCENTCOLOR=#89dceb
    elif [[ $FLAVOUR == "Macchiato" ]]; then
        ACCENTCOLOR=#91d7e3
    elif [[ $FLAVOUR == "Frappe" ]]; then
        ACCENTCOLOR=#99d1db
    elif [[ $FLAVOUR == "Latte" ]]; then
        ACCENTCOLOR=#04a5e5
    fi
    echo "Accent Sky(11) was selected!"
elif [[ $ACCENT == "Sapphire" ]]; then
    if [[ $FLAVOUR == "Mocha" ]]; then
        ACCENTCOLOR=#74c7ec
    elif [[ $FLAVOUR == "Macchiato" ]]; then
        ACCENTCOLOR=#7dc4e4
    elif [[ $FLAVOUR == "Frappe" ]]; then
        ACCENTCOLOR=#85c1dc
    elif [[ $FLAVOUR == "Latte" ]]; then
        ACCENTCOLOR=#209fb5
    fi
    echo "Accent Sapphire(12) was selected!"
elif [[ $ACCENT == "Blue" ]]; then
    if [[ $FLAVOUR == "Mocha" ]]; then
        ACCENTCOLOR=#89b4fa
    elif [[ $FLAVOUR == "Macchiato" ]]; then
        ACCENTCOLOR=#8aadf4
    elif [[ $FLAVOUR == "Frappe" ]]; then
        ACCENTCOLOR=#8caaee
    elif [[ $FLAVOUR == "Latte" ]]; then
        ACCENTCOLOR=#1e66f5
    fi
    echo "Accent Blue(13) was selected!"
elif [[ $ACCENT == "Lavender" ]]; then
    if [[ $FLAVOUR == "Mocha" ]]; then
        ACCENTCOLOR=#b4befe
    elif [[ $FLAVOUR == "Macchiato" ]]; then
        ACCENTCOLOR=#b7bdf8
    elif [[ $FLAVOUR == "Frappe" ]]; then
        ACCENTCOLOR=#babbf1
    elif [[ $FLAVOUR == "Latte" ]]; then
        ACCENTCOLOR=#7287fd
    fi
    echo "Accent Lavender(14) was selected!"
else echo "Not a valid accent" && exit
fi

if [[ $WINDECSTYLE == "Modern" ]]; then
    WINDECSTYLECODE=__aurorae__svg__Catppuccin$FLAVOUR-Modern
elif [[ $WINDECSTYLE == "Classic" ]]; then
    WINDECSTYLECODE=__aurorae__svg__Catppuccin$FLAVOUR-Classic
fi

function ModifyLightlyPlasma {

    rm -rf $DESKTOPTHEMEDIR/lightly-plasma-git/icons/*
    rm -rf $DESKTOPTHEMEDIR/lightly-plasma-git/translucent
    rm $DESKTOPTHEMEDIR/lightly-plasma-git/widgets/tabbar.svgz
    rm $DESKTOPTHEMEDIR/lightly-plasma-git/dialogs/background.svgz

    # Copy Patches
    cp $DESKTOPTHEMEDIR/lightly-plasma-git/solid/* $DESKTOPTHEMEDIR/lightly-plasma-git -Rf
    cp ./Patches/glowbar.svg $DESKTOPTHEMEDIR/lightly-plasma-git/widgets -rf
    cp ./Patches/background.svg $DESKTOPTHEMEDIR/lightly-plasma-git/widgets -rf
    cp ./Patches/panel-background.svgz $DESKTOPTHEMEDIR/lightly-plasma-git/widgets

    # Modify description to state that it has been modified by the KDE Catppuccin Installer
    sed -e s/A\ plasma\ style\ with\ close\ to\ the\ look\ of\ the\ newest\ Lightly./*MODIFIED\ BY\ CATPPUCCIN\ KDE\ INSTALLER*\ A\ plasma\ style\ with\ close\ to\ the\ look\ of\ the\ newest\ Lightly./g $DESKTOPTHEMEDIR/lightly-plasma-git/metadata.desktop >> $DESKTOPTHEMEDIR/lightly-plasma-git/newMetadata.desktop
    cp -f $DESKTOPTHEMEDIR/metadata.desktop $DESKTOPTHEMEDIR/lightly-plasma-git/metadata.desktop && rm $DESKTOPTHEMEDIR/metadata.desktop
}

function AuroraeInstall {
    if [[ $WINDECSTYLE == "Modern" ]]; then
        cp ./Resources/aurorae/Catppuccin$FLAVOUR-Modern $AURORAEDIR -r;
    elif [[ $WINDECSTYLE == "Classic" ]]; then
        cp ./Resources/aurorae/Catppuccin$FLAVOUR-Classic $AURORAEDIR -r;
    fi
}

function BuildColorscheme {
    # Add Metadata & Replace Accent in colors file
    sed -e s/--accentColor/$ACCENTCOLOR/g -e s/--flavour/$FLAVOUR/g -e s/--accentName/$ACCENT/g ./Resources/base.colors > ./dist/base.colors
    # Hydrate Metadata with Pallet + Accent Info
    sed -e s/--accentName/$ACCENT/g -e s/--flavour/$FLAVOUR/g ./Resources/metadata.desktop > ./dist/Catppuccin-$FLAVOUR-$ACCENT/metadata.desktop
    # Modify 'defaults' to set the correct Aurorae Theme
    sed -e s/--accentName/$ACCENT/g -e s/--flavour/$FLAVOUR/g -e s/--aurorae/$WINDECSTYLECODE/g ./Resources/defaults > ./dist/Catppuccin-$FLAVOUR-$ACCENT/contents/defaults
    # Hydrate Dummy colors according to Pallet
    FLAVOURNAME=$FLAVOUR ACCENTNAME=$ACCENT ./Installer/color-build.sh -o ./dist/Catppuccin$FLAVOUR$ACCENT.colors -s ./dist/base.colors
}

function BuildSplashScreen {
    # Hydrate Dummy colors according to Pallet
    FLAVOURNAME=$FLAVOUR ./Installer/color-build.sh -s ./Resources/splash/images/busywidget.svg -o ./dist/$GLOBALTHEMENAME/contents/splash/images/_busywidget.svg
    # Replace Accent in colors file
    sed ./dist/$GLOBALTHEMENAME/contents/splash/images/_busywidget.svg -e s/REPLACE--ACCENT/$ACCENTCOLOR/g > ./dist/$GLOBALTHEMENAME/contents/splash/images/busywidget.svg
    # Cleanup temporary file
    rm ./dist/$GLOBALTHEMENAME/contents/splash/images/_busywidget.svg
    # Hydrate Dummy colors according to Pallet (QML file)
    FLAVOURNAME=$FLAVOUR ./Installer/color-build.sh -s ./Resources/splash/Splash.qml -o ./dist/$GLOBALTHEMENAME/contents/splash/Splash.qml
    # Add CTP Logo
    # TODO: Switch between latte & mocha logo based on Pallet
    cp ./Resources/splash/images/Logo.png ./dist/$GLOBALTHEMENAME/contents/splash/images
}

# Prepare Global Theme Folder
GLOBALTHEMENAME="Catppuccin-$FLAVOUR-$ACCENT"
cp -r ./Resources/Catppuccin-$FLAVOUR-Global ./dist/$GLOBALTHEMENAME
mkdir -p ./dist/$GLOBALTHEMENAME/contents/splash/images

# Build SplashScreen
echo "Building SplashScreen.."
BuildSplashScreen

# Build Colorscheme
echo "Building Colorscheme.."
# Generate Color scheme
BuildColorscheme

# Install Colorscheme
echo "Installing Colorscheme.."
mv ./dist/Catppuccin$FLAVOUR$ACCENT.colors $COLORDIR

# Install Global Theme.
echo "Installing Global Theme.."
cp -r ./dist/$GLOBALTHEMENAME $LOOKANDFEELDIR

# echo "Modifying lightly plasma theme.."
# ModifyLightlyPlasma

echo "Installing aurorae theme.."
AuroraeInstall

# Cleanup
echo "Cleaning up.."
rm -rf ./dist
