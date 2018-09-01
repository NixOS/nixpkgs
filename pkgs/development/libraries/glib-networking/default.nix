{ stdenv, fetchurl, fetchpatch, meson, ninja, pkgconfig, glib, gettext, gnutls, p11-kit, libproxy, gnome3
, gsettings-desktop-schemas }:

let
  pname = "glib-networking";
  version = "2.56.0";
in
stdenv.mkDerivation rec {
  name = "${pname}-${version}";

  src = fetchurl {
    url = "mirror://gnome/sources/${pname}/${gnome3.versionBranch version}/${name}.tar.xz";
    sha256 = "14vw8xwajd7m31bpavg2psk693plhjikwpk8bzf3jl1fmsy11za7";
  };

  outputs = [ "out" "dev" ]; # to deal with propagatedBuildInputs

  patches = [
    # Use GNUTLS system trust for certificates
    (fetchpatch {
      url = https://gitlab.gnome.org/GNOME/glib-networking/commit/f1c8feee014007cc913b71357acb609f8d1200df.patch;
      sha256 = "1rbxqsrcb5if3xs2d18pqzd9xnjysdj715ijc41n5w326fsawg7i";
    })
  ];

  PKG_CONFIG_GIO_2_0_GIOMODULEDIR = "${placeholder "out"}/lib/gio/modules";

  postPatch = ''
    chmod +x meson_post_install.py # patchShebangs requires executable file
    patchShebangs meson_post_install.py
  '';

  nativeBuildInputs = [ meson ninja pkgconfig gettext ];
  propagatedBuildInputs = [ glib gnutls p11-kit libproxy gsettings-desktop-schemas ];

  doCheck = false; # tests need to access the certificates (among other things)

  passthru = {
    updateScript = gnome3.updateScript {
      packageName = pname;
    };
  };

  meta = with stdenv.lib; {
    description = "Network-related giomodules for glib";
    license = licenses.lgpl2Plus;
    platforms = platforms.unix;
  };
}
