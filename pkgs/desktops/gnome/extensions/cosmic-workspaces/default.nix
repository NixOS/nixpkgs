{ stdenv, lib, fetchFromGitHub, glib }:

stdenv.mkDerivation rec {
  pname = "gnome-shell-extension-cosmic-workspaces";
  version = "unstable-2021-11-03";

  src = fetchFromGitHub {
    owner = "pop-os";
    repo = "cosmic-workspaces";
    # from branch `master_impish`
    rev = "678b34bdcdec14471665b87092ca16f6857dac66";
    sha256 = "sha256-RhdNG9FQRat4mBNfB5G1VflzzyixXfdOUg4BfmPceCQ=";
  };

  nativeBuildInputs = [ glib ];

  makeFlags = [ "XDG_DATA_HOME=$(out)/share" ];

  passthru = {
    extensionUuid = "cosmic-workspaces@system76.com";
    extensionPortalSlug = "cosmic-workspaces";
  };

  meta = with lib; {
    description = "Vertically stacked workspaces (Pop!_OS fork)";
    license = licenses.gpl3Only;
    platforms = platforms.linux;
    maintainers = with maintainers; [ Enzime ];
    homepage = "https://github.com/pop-os/cosmic-workspaces";
  };
}
