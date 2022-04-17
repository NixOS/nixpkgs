let
  nixpkgs = import <nixpkgs> {};

  inherit (nixpkgs) libsForQt5 pkgs stdenv lib polkit;
/*
  mauikit = stdenv.mkDerivation rec {
    pname = "mauikit";
    version = "2.1.1";

    src = builtins.fetchGit {
      url = "https://invent.kde.org/maui/mauikit.git";
      ref = "refs/tags/v${version}";
      rev = "6cdccd562f657e6c397e0eddbadaf3a6be395603";
    };

    nativeBuildInputs = with pkgs; [ cmake libsForQt5.wrapQtAppsHook ];
    buildInputs = with pkgs; [ extra-cmake-modules libsForQt5.kwindowsystem qt5.full libsForQt5.kconfig libsForQt5.knotifications libsForQt5.ki18n ];

    enableParallelBuilding = true;
  };

  mauikit-filebrowsing = stdenv.mkDerivation rec {
    pname = "mauikit-filebrowsing";
    version = "2.1.1";

    src = builtins.fetchGit {
      url = "https://invent.kde.org/maui/mauikit-filebrowsing.git";
      ref = "refs/tags/v${version}";
      rev = "aca5421777b2c49e221ceddc8afc6e8e52a40318";
    };

    nativeBuildInputs = with pkgs; [ cmake libsForQt5.wrapQtAppsHook ];

    buildInputs = with pkgs; [ extra-cmake-modules libsForQt5.kwindowsystem qt5.full libsForQt5.kconfig libsForQt5.knotifications libsForQt5.ki18n libsForQt5.kio mauikit ];

    enableParallelBuilding = true;
  };
*/
  maui-shell = mkDerivation rec {
    pname = "maui-shell";
    version = "0.5.0";

    src = builtins.fetchGit {
      url = "https://github.com/Nitrux/maui-shell.git";
      ref = "refs/tags/v${version}";
      rev = "61ae7f296097700359efc96ad91b7d984434c543";
    };

    nativeBuildInputs = with pkgs; [ cmake libsForQt5.wrapQtAppsHook ];

    buildInputs = with pkgs; [ extra-cmake-modules libsForQt5.kwindowsystem qt5.full 
      libsForQt5.kconfig libsForQt5.knotifications libsForQt5.ki18n libsForQt5.kio 
      libsForQt5.krunner libsForQt5.kactivities 
      libsForQt5.kwayland libsForQt5.prison libsForQt5.kpackage libsForQt5.knotifyconfig libsForQt5.kidletime 
      libsForQt5.kpeople libsForQt5.kdesu libsForQt5.kactivities-stats
      libsForQt5.ktexteditor libsForQt5.kinit libsForQt5.kunitconversion
      libsForQt5.kitemmodels libsForQt5.phonon libsForQt5.polkit-qt libsForQt5.kauth
      libsForQt5.polkit-kde-agent polkit libsForQt5.mauikit libsForQt5.mauikit-filebrowsing
    ];

    enableParallelBuilding = true;
  };

in maui-shell
