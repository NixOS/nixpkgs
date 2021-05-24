{ lib, stdenv, fetchFromGitHub, fetchpatch, glib, gettext }:

stdenv.mkDerivation rec {
  pname = "gnome-shell-extension-topicons-plus";
  version = "27";

  src = fetchFromGitHub {
    owner = "phocean";
    repo = "TopIcons-plus";
    rev = version;
    sha256 = "1p3jlvs4zgnrvy8am7myivv4rnnshjp49kg87rd22qqyvcz51ykr";
  };

  patches = [
    # GNOME 40 compatibility (from https://github.com/phocean/TopIcons-plus/pull/156)
    (fetchpatch {
      url = "https://github.com/phocean/TopIcons-plus/commit/98cd17aa324a031e2ee3d344582dfdafd1e4642f.diff";
      sha256 = "1c2j0yy7zbn6jzpqkla150gxlhgfz85y2rscx9vz7cgyzdl0q112";
    })
  ];

  buildInputs = [ glib ];

  nativeBuildInputs = [ gettext ];

  makeFlags = [ "INSTALL_PATH=$(out)/share/gnome-shell/extensions" ];

  uuid = "TopIcons@phocean.net";

  meta = with lib; {
    description = "Brings all icons back to the top panel, so that it's easier to keep track of apps running in the backround";
    license = licenses.gpl2Only;
    maintainers = with maintainers; [ eduardosm ];
    homepage = "https://github.com/phocean/TopIcons-plus";
  };
}
