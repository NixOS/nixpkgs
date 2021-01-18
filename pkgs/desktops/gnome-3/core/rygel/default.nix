{ lib, stdenv
, fetchurl
, meson
, ninja
, pkg-config
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
  version = "0.40.0";

  # TODO: split out lib
  outputs = [ "out" "dev" ];

  src = fetchurl {
    url = "mirror://gnome/sources/${pname}/${lib.versions.majorMinor version}/${pname}-${version}.tar.xz";
    sha256 = "0xrbdsgm78h3g4qcvq2p8k70q31x9xdbb35bixz36q6h9s1wqznn";
  };

  nativeBuildInputs = [
    meson
    ninja
    pkg-config
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
    gst-editing-services
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
    # Build all plug-ins except for tracker 2
    "-Dplugins=external,gst-launch,lms,media-export,mpris,playbin,ruih,tracker3"
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

  meta = with lib; {
    description = "A home media solution (UPnP AV MediaServer) that allows you to easily share audio, video and pictures to other devices";
    homepage = "https://wiki.gnome.org/Projects/Rygel";
    license = licenses.lgpl21Plus;
    maintainers = teams.gnome.members;
    platforms = platforms.linux;
  };
}
