{ stdenv, fetchurl, fetchFromGitHub, pkgconfig, gtk3, vala, cmake, vte, libgee, wnck, zssh, gettext, librsvg, libsecret, json-glib, gobjectIntrospection }:

stdenv.mkDerivation rec {
  name = "deepin-terminal-${version}";
  version = "2.9.2";

  src = fetchFromGitHub {
    owner = "linuxdeepin";
    repo = "deepin-terminal";
    rev = version;
    sha256 = "1pmg1acs44c30hz9rpr6x1l6lyvlylc2pz5lv4ai0rhv37n51yn2";
  };

  patches = [
    # Do not build vendored zssh and vte
    (fetchurl {
      name = "remove-vendor.patch";
      url = https://git.archlinux.org/svntogit/community.git/plain/trunk/remove-vendor.patch?h=packages/deepin-terminal&id=5baa756e8e6ac8ce43fb122fce270756cc55086c;
      sha256 = "0zrq004malphpy7xv5z502bpq30ybyj1rr4hlq4k5m4fpk29dlw6";
    })
  ];

  postPatch = ''
    substituteInPlace project_path.c --replace __FILE__ \"$out/share/deepin-terminal/\"
    substituteInPlace ssh_login.sh --replace /usr/lib/deepin-terminal/zssh "${zssh}/bin/zssh"
  '';

  nativeBuildInputs = [
    pkgconfig vala cmake gettext
    # For setup hook
    gobjectIntrospection
  ];
  buildInputs = [ gtk3 vte libgee wnck librsvg libsecret json-glib ];

  meta = with stdenv.lib; {
    description = "The default terminal emulation for Deepin";
    longDescription = ''
      Deepin terminal, it sharpens your focus in the world of command line!
      It is an advanced terminal emulator with workspace, multiple windows, remote management, quake mode and other features.
     '';
    homepage = https://github.com/linuxdeepin/deepin-terminal/;
    license = licenses.gpl3;
    maintainers = with maintainers; [ ];
    platforms = platforms.linux;
  };
}
