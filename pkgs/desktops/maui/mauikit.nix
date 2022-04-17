#{ lib, stdenv, fetchFromGitHub, autoconf, libtool, automake, pkg-config, git
#, flex, ripgrep, gettext }:

with import <nixpkgs> {};

libsForQt5.mkDerivation rec {
  pname = "mauikit";
  version = "2.1.1";

  src = builtins.fetchGit {
    url = "https://invent.kde.org/maui/mauikit.git";
    ref = "refs/tags/v${version}";
    rev = "6cdccd562f657e6c397e0eddbadaf3a6be395603";
  };

  nativeBuildInputs = with pkgs; [ cmake ];
#dontUseCmakeConfigure = true;
  buildInputs = with pkgs; [ extra-cmake-modules libsForQt5.kwindowsystem qt5.full libsForQt5.kconfig libsForQt5.knotifications libsForQt5.ki18n ];

  #dontWrapQtApps = true;
  enableParallelBuilding = true;
  
  #cmakeFlags = [ ];

  meta = with lib; {
    description = "Implements the Stellar Consensus Protocol, a federated consensus protocol";
    longDescription = ''
      Stellar-core is the backbone of the Stellar network. It maintains a
      local copy of the ledger, communicating and staying in sync with other
      instances of stellar-core on the network. Optionally, stellar-core can
      store historical records of the ledger and participate in consensus.
    '';
    homepage = "https://www.stellar.org/";
    platforms = [ "x86_64-linux" ];
    maintainers = with maintainers; [ ];
    license = licenses.asl20;
  };
}
