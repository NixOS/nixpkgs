{
  lib,
  stdenv,
  fetchFromGitHub,
  glib,
  gettext,
}:

stdenv.mkDerivation rec {
  pname = "gnome-shell-extension-topicons-plus";
  version = "27";

  src = fetchFromGitHub {
    owner = "phocean";
    repo = "TopIcons-plus";
    rev = version;
    sha256 = "1p3jlvs4zgnrvy8am7myivv4rnnshjp49kg87rd22qqyvcz51ykr";
  };

  buildInputs = [ glib ];

  nativeBuildInputs = [ gettext ];

  makeFlags = [ "INSTALL_PATH=$(out)/share/gnome-shell/extensions" ];

  passthru.extensionUuid = "TopIcons@phocean.net";

  meta = with lib; {
    description = "Brings all icons back to the top panel, so that it's easier to keep track of apps running in the backround";
    license = licenses.gpl2Only;
    maintainers = with maintainers; [ eperuffo ];
    homepage = "https://github.com/phocean/TopIcons-plus";
  };
}
