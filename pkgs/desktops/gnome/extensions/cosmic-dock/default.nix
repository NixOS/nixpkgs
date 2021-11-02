{ stdenv, lib, fetchFromGitHub, glib, sassc }:

stdenv.mkDerivation rec {
  pname = "gnome-shell-extension-cosmic-dock";
  version = "unstable-2021-11-03";

  src = fetchFromGitHub {
    owner = "pop-os";
    repo = "cosmic-dock";
    # from branch `master_impish`
    rev = "acb33c1c25866655e11191a781055ac272acfdc3";
    sha256 = "sha256-MM5E8T6xWamfi7ABgTgG8WmuX0bvdmZHu8bmys1og2k=";
  };

  nativeBuildInputs = [ glib sassc ];

  makeFlags = [ "XDG_DATA_HOME=$(out)/share" ];

  passthru = {
    extensionUuid = "cosmic-dock@system76.com";
    extensionPortalSlug = "cosmic-dock";
  };

  meta = with lib; {
    description = "Cosmic Dock (Pop!_OS fork of Ubuntu Dock)";
    license = licenses.gpl3Only;
    platforms = platforms.linux;
    maintainers = with maintainers; [ Enzime ];
    homepage = "https://github.com/pop-os/cosmic-dock";
  };
}
