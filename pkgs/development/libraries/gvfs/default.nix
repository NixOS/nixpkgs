{ stdenv, fetchurl, meson, ninja, pkgconfig, gettext, gnome3, dbus
, glib, libgudev, udisks2, libgcrypt, libcap, polkit, fetchpatch
, libgphoto2, avahi, libarchive, fuse, libcdio
, libxml2, libxslt, docbook_xsl, docbook_xml_dtd_42, samba, libmtp
, gnomeSupport ? false, gnome, gcr, wrapGAppsHook
, libimobiledevice, libbluray, libcdio-paranoia, libnfs, openssh
, libsecret, libgdata, python3
}:

let
  pname = "gvfs";
  version = "1.40.1";
in stdenv.mkDerivation rec {
  name = "${pname}-${version}";

  src = fetchurl {
    url = "mirror://gnome/sources/${pname}/${stdenv.lib.versions.majorMinor version}/${name}.tar.xz";
    sha256 = "1cfnzamr4mvgpf6yhm28lh9cafy9z6842s8jpbqnfizfxybg8ylj";
  };

  patches = [
    # CVE-2019-12448
    (fetchpatch {
      url = "https://gitlab.gnome.org/GNOME/gvfs/commit/464bbc7e4e7fdfc3cb426557562038408b6108c5.patch";
      sha256 = "03fwlpj1vbi80661bbhzv8ddx3czkzv9i1q4h3gqyxi5f1i0xfz4";
    })
    # CVE-2019-12447
    (fetchpatch {
      url = "https://gitlab.gnome.org/GNOME/gvfs/commit/cf2f9c4020bbdd895485244b70e9442a80062cbe.patch";
      sha256 = "1p7c48nsx1lkv2qpkyrsm9qfa77xwd28gczwcpv2kbji3ws5qgj5";
    })
    (fetchpatch {
      url = "https://gitlab.gnome.org/GNOME/gvfs/commit/64156459a366d64ab19187455016929b1026189a.patch";
      sha256 = "0zxbhmgqxxw987ag8fh6yjzjn9jl55fqbn814jh9kwrk7x4prx9x";
    })
    # CVE-2019-12449
    (fetchpatch {
      url = "https://gitlab.gnome.org/GNOME/gvfs/commit/ec939a01c278d1aaa47153f51b5c5f0887738dd9.patch";
      sha256 = "0hfybfaz2gfx3yyw5ymx6q0pqwkx2r1i7gzprfp80bplwslq0d4h";
    })
    # CVE-2019-12795
    (fetchpatch {
      url = "https://gitlab.gnome.org/GNOME/gvfs/commit/d8c9138bf240975848b1c54db648ec4cd516a48f.patch";
      sha256 = "1lx6yxykx24mnq5izijqk744zj6rgww6ba76z0qjal4y0z3gsdqp";
    })
  ];

  postPatch = ''
    # patchShebangs requires executable file
    chmod +x meson_post_install.py
    patchShebangs meson_post_install.py
    patchShebangs test test-driver
  '';

  nativeBuildInputs = [
    meson ninja python3
    pkgconfig gettext wrapGAppsHook
    libxml2 libxslt docbook_xsl docbook_xml_dtd_42
  ];

  buildInputs = [
    glib libgudev udisks2 libgcrypt dbus
    libgphoto2 avahi libarchive fuse libcdio
    samba libmtp libcap polkit libimobiledevice libbluray
    libcdio-paranoia libnfs openssh
    # ToDo: a ligther version of libsoup to have FTP/HTTP support?
  ] ++ stdenv.lib.optionals gnomeSupport (with gnome; [
    libsoup gcr
    glib-networking # TLS support
    gnome-online-accounts libsecret libgdata
  ]);

  mesonFlags = [
    "-Dsystemduserunitdir=${placeholder "out"}/lib/systemd/user"
    "-Dtmpfilesdir=no"
  ] ++ stdenv.lib.optionals (!gnomeSupport) [
    "-Dgcr=false" "-Dgoa=false" "-Dkeyring=false" "-Dhttp=false"
    "-Dgoogle=false"
  ] ++ stdenv.lib.optionals (samba == null) [
    # Xfce don't want samba
    "-Dsmb=false"
  ];

  doCheck = false; # fails with "ModuleNotFoundError: No module named 'gi'"
  doInstallCheck = doCheck;

  passthru = {
    updateScript = gnome3.updateScript {
      packageName = pname;
    };
  };

  meta = with stdenv.lib; {
    description = "Virtual Filesystem support library" + optionalString gnomeSupport " (full GNOME support)";
    license = licenses.lgpl2Plus;
    platforms = platforms.linux;
    maintainers = [ maintainers.lethalman ] ++ gnome3.maintainers;
  };
}
