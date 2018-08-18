{ stdenv, fetchurl, fetchFromGitHub, pkgconfig, gtk3, vala, cmake, ninja, vte, libgee, wnck, zssh, gettext, librsvg, libsecret, json-glib, gobjectIntrospection }:

stdenv.mkDerivation rec {
  name = "deepin-terminal-${version}";
  version = "3.0.0";

  src = fetchFromGitHub {
    owner = "linuxdeepin";
    repo = "deepin-terminal";
    rev = version;
    sha256 = "11f2yc0fj05lwhgvdrbrs8xsdm7qgp6wb5wd1f9iyc5nxn7ccl1r";
  };

  patches = [
    # Do not build vendored zssh and vte
    (fetchurl {
      name = "remove-vendor.patch";
      url = https://git.archlinux.org/svntogit/community.git/plain/trunk/remove-vendor.patch?h=packages/deepin-terminal&id=de701614c19c273b98b60fd6790795ff7d8a157e;
      sha256 = "0g7hhvr7ay9g0cgc6qqvzhbcwvbzvrrilbn8w46ypfzj7w5hlkqv";
    })
  ];

  postPatch = ''
    substituteInPlace ssh_login.sh --replace /usr/lib/deepin-terminal/zssh "${zssh}/bin/zssh"
  '';

  nativeBuildInputs = [
    pkgconfig vala cmake ninja gettext
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
