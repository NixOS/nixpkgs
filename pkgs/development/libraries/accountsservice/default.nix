{ stdenv
, fetchurl
, fetchpatch
, substituteAll
, pkgconfig
, glib
, shadow
, gobject-introspection
, polkit
, systemd
, coreutils
, meson
, dbus
, ninja
, python3
, gettext
}:

stdenv.mkDerivation rec {
  pname = "accountsservice";
  version = "0.6.55";

  outputs = [ "out" "dev" ];

  src = fetchurl {
    url = "https://www.freedesktop.org/software/${pname}/${pname}-${version}.tar.xz";
    sha256 = "16wwd633jak9ajyr1f1h047rmd09fhf3kzjz6g5xjsz0lwcj8azz";
  };

  nativeBuildInputs = [
    dbus
    gettext
    gobject-introspection
    meson
    ninja
    pkgconfig
    python3
  ];

  buildInputs = [
    glib
    polkit
  ];

  mesonFlags = [
    "-Dadmin_group=wheel"
    "-Dlocalstatedir=/var"
    "-Dsystemdsystemunitdir=${placeholder ''out''}/etc/systemd/system"
  ];

  postPatch = ''
    chmod +x meson_post_install.py
    patchShebangs meson_post_install.py
  '';

  patches = [
    (substituteAll {
      src = ./fix-paths.patch;
      inherit shadow coreutils;
    })
    ./no-create-dirs.patch
    ./Disable-methods-that-change-files-in-etc.patch
    # Systemd unit improvements. Notably using StateDirectory eliminating the
    # need of an ad-hoc script.
    (fetchpatch {
      url = "https://gitlab.freedesktop.org/accountsservice/accountsservice/commit/152b845bbd3ca2a64516691493a160825f1a2046.patch";
      sha256 = "114wrf5mwj5bgc5v1g05md4ridcnwdrwppr3bjz96sknwh5hk8s5";
    })
    (fetchpatch {
      url = "https://gitlab.freedesktop.org/accountsservice/accountsservice/commit/0e712e935abd26499ff5995ab363e5bfd9ee7c4c.patch";
      sha256 = "1y60a5fmgfqjzprwpizilrazqn3mggdlgc5sgcpsprsp62fv78rl";
    })
  ];

  meta = with stdenv.lib; {
    description = "D-Bus interface for user account query and manipulation";
    homepage = https://www.freedesktop.org/wiki/Software/AccountsService;
    license = licenses.gpl3;
    maintainers = with maintainers; [ pSub ];
    platforms = with platforms; linux;
  };
}
