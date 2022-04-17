{ pkgs, mkDerivation, qtbase, fetchFromGitHub, qtquickcontrols2, cmake, 
  extra-cmake-modules, kwindowsystem, kconfig, knotifications, ki18n, kio,
  krunner, kactivities, kwayland, prison, kpackage, knotifyconfig, kidletime,
  kpeople, kdesu, kactivities-stats,
  ktexteditor, kinit, kunitconversion,
  kitemmodels, phonon, polkit-qt, kauth,
  polkit-kde-agent, polkit, mauikit, mauikit-filebrowsing,
  bluedevil, plasma-pa, plasma-nm, kdelibs4support, bluez-qt }:

mkDerivation rec {
  pname = "maui-shell";
  version = "0.5.0";

  src = fetchFromGitHub {
    repo = "maui-shell";
    owner = "Nitrux";

    #url = "https://github.com/Nitrux/maui-shell.git";
    rev = "master";
    sha256 = "sha256-h/7oQVFSnJbFEGEsOc5DxR2xJEIZ2FYWYb9sMV/DHS0="; 
    #rev = "60472aff5cd9c309286c162ee1c468c5a6bba57d";
    #ref = "refs/tags/v${version}";
    #rev = "61ae7f296097700359efc96ad91b7d984434c543";
  };
 
  nativeBuildInputs = [ cmake ];

  buildInputs = [ extra-cmake-modules kwindowsystem 
      kconfig knotifications ki18n kio 
      krunner kactivities qtbase qtquickcontrols2 
      kwayland prison kpackage knotifyconfig kidletime 
      kpeople kdesu kactivities-stats
      ktexteditor kinit kunitconversion
      kitemmodels phonon polkit-qt kauth
      polkit-kde-agent polkit mauikit mauikit-filebrowsing
      plasma-nm bluedevil kdelibs4support plasma-pa bluez-qt
  ];
  
  #postInstall = ''
  #  addToSearchPath QML2_IMPORT_PATH "${qt5.full}/lib/qt5/qml"
  #  wrapProgram $out/bin/cask \
  #    --prefix QML_IMPORT_PATH : "$QML_IMPORT_PATH" \
  #    --prefix QML2_IMPORT_PATH : "$QML2_IMPORT_PATH"
  #'';

  preFixup = ''
    gapsWrapperArgs+=(
      --set QT_QPA_PLATFORM "xcb"
    )
  '';

  enableParallelBuilding = true;
}

