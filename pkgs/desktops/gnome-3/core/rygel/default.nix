{ stdenv
, fetchurl
, meson
, ninja
, pkgconfig
, vala
, gettext
, libxml2
, gobject-introspection
, wrapGAppsHook
, python3
, glib
, gssdp
, gupnp
, gupnp-av
, gupnp-dlna
, gst_all_1
, libgee
, libsoup
, gtk3
, libmediaart
, sqlite
, systemd
, tracker
, shared-mime-info
, gnome3
}:

stdenv.mkDerivation rec {
  pname = "rygel";
  version = "0.38.0";

  # TODO: split out lib
  outputs = [ "out" "dev" ];

  src = fetchurl {
    url = "mirror://gnome/sources/${pname}/${stdenv.lib.versions.majorMinor version}/${pname}-${version}.tar.xz";
    sha256 = "03ky18hwcz362lbhqm1zm0ax2a075r69xms5cznchn9p9w8z5axc";
  };

  nativeBuildInputs = [
    meson
    ninja
    pkgconfig
    vala
    gettext
    libxml2
    gobject-introspection
    wrapGAppsHook
    python3
  ];

  buildInputs = [
    glib
    gssdp
    gupnp
    gupnp-av
    gupnp-dlna
    libgee
    libsoup
    gtk3
    libmediaart
    sqlite
    systemd
    tracker
    shared-mime-info
  ] ++ (with gst_all_1; [
    gstreamer
    gst-plugins-base
    gst-plugins-good
    gst-plugins-bad
    gst-plugins-ugly
  ]);

  mesonFlags = [
    "-Dsystemd-user-units-dir=${placeholder "out"}/lib/systemd/user"
    "-Dapi-docs=false"
    "--sysconfdir=/etc"
    "-Dsysconfdir_install=${placeholder "out"}/etc"
  ];

  doCheck = true;

  patches = [
    ./add-option-for-installation-sysconfdir.patch
  ];

  postPatch = ''
    patchShebangs data/xml/process-xml.py
  '';

  passthru = {
    updateScript = gnome3.updateScript {
      packageName = pname;
      attrPath = "gnome3.${pname}";
    };
  };

  meta = with stdenv.lib; {
    description = "A home media solution (UPnP AV MediaServer) that allows you to easily share audio, video and pictures to other devices";
    homepage = https://wiki.gnome.org/Projects/Rygel;
    license = licenses.lgpl21Plus;
    maintainers = gnome3.maintainers;
    platforms = platforms.linux;
  };
}
