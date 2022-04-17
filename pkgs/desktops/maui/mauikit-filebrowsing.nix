let
  nixpkgs = import <nixpkgs> {};

  inherit (nixpkgs) libsForQt5 pkgs;

  mauikit = libsForQt5.mkDerivation rec {
    pname = "mauikit";
    version = "2.1.1";

    src = builtins.fetchGit {
      url = "https://invent.kde.org/maui/mauikit.git";
      ref = "refs/tags/v${version}";
      rev = "6cdccd562f657e6c397e0eddbadaf3a6be395603";
    };

    nativeBuildInputs = with pkgs; [ cmake ];
    buildInputs = with pkgs; [ extra-cmake-modules libsForQt5.kwindowsystem qt5.full libsForQt5.kconfig libsForQt5.knotifications libsForQt5.ki18n ];

    enableParallelBuilding = true;
  };

  mauikit-filebrowsing = libsForQt5.mkDerivation rec {
    pname = "mauikit-filebrowsing";
    version = "2.1.1";

    src = builtins.fetchGit {
      url = "https://invent.kde.org/maui/mauikit-filebrowsing.git";
      ref = "refs/tags/v${version}";
      rev = "aca5421777b2c49e221ceddc8afc6e8e52a40318";
    };

    nativeBuildInputs = with pkgs; [ cmake ];

    buildInputs = with pkgs; [ extra-cmake-modules libsForQt5.kwindowsystem qt5.full libsForQt5.kconfig libsForQt5.knotifications libsForQt5.ki18n libsForQt5.kio mauikit ];

    enableParallelBuilding = true;
  };

  mau-shell = libsForQt5.mkDerivation rec {
    pname = "maui-shell";
    version = "0.5.0";

    src = builtins.fetchGit {
      url = "https://github.com/Nitrux/maui-shell.git";
      ref = "refs/tags/v${version}";
      rev = "61ae7f296097700359efc96ad91b7d984434c543";
    };

    nativeBuildInputs = with pkgs; [ cmake ];

    buildInputs = with pkgs; [ extra-cmake-modules libsForQt5.kwindowsystem qt5.full libsForQt5.kconfig libsForQt5.knotifications libsForQt5.ki18n libsForQt5.kio mauikit mauikit-filebrowsing ];

    enableParallelBuilding = true;
  };

in maui-shell
