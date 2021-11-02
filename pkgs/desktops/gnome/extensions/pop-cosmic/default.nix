{ stdenv, lib, fetchFromGitHub, glib }:

stdenv.mkDerivation rec {
  pname = "gnome-shell-extension-pop-cosmic";
  version = "unstable-2021-11-03";

  src = fetchFromGitHub {
    owner = "pop-os";
    repo = "cosmic";
    # from branch `master_impish`
    rev = "fbcaa2c071330a73e7b13b407e8b7fb0251eeace";
    sha256 = "sha256-hgEbGG3ZQwSCeMvu8NiPA6SdO+Y2THD/nEoTzRRxdFs=";
  };

  nativeBuildInputs = [ glib ];

  makeFlags = [ "XDG_DATA_HOME=$(out)/share" ];

  passthru = {
    extensionUuid = "pop-cosmic@system76.com";
    extensionPortalSlug = "pop-cosmic";
  };

  meta = with lib; {
    description = "Computer Operating System Main Interface Components";
    license = licenses.gpl3Only;
    platforms = platforms.linux;
    maintainers = with maintainers; [ Enzime ];
    homepage = "https://github.com/pop-os/cosmic";
  };
}
