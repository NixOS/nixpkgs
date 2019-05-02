{ fetchFromGitLab, stdenv, substituteAll, pkgconfig, gnome3, intltool, gobject-introspection, upower, cairo
, glib, gtk3, pango, cogl, clutter, libstartup_notification, zenity, libcanberra-gtk3, fetchpatch
, gsettings-desktop-schemas, gnome-desktop, wrapGAppsHook
, libtool, makeWrapper, xkeyboard_config, libxkbfile, libxkbcommon, libXtst, libinput
, geocode-glib, libgudev, libwacom, xwayland, autoreconfHook }:

stdenv.mkDerivation rec {
  pname = "mutter";
  version = "3.28.3";

  src = fetchFromGitLab {
    domain = "gitlab.gnome.org";
    owner = "GNOME";
    repo = pname;
    rev = "4af8d9d4752a94612a98d619e65828f0070a7b0e"; # HEAD of https://gitlab.gnome.org/GNOME/mutter/tree/gnome-3-28
    sha256 = "1rmc1bf80yq776xhygi1jzgia1y44j2mr2n94vlxgzqc0whamx2v";
  };

  patches = [
    (substituteAll {
      src = ./fix-paths-328.patch;
      inherit zenity;
    })

    # https://bugzilla.redhat.com/show_bug.cgi?id=1700337
    # https://gitlab.gnome.org/GNOME/mutter/merge_requests/133
    (fetchpatch {
      url = "https://src.fedoraproject.org/rpms/mutter328/raw/fff28bebda02111b4c534952465ff967ba7efced/f/0070-clutter-Add-API-to-retrieve-the-physical-size-of-abs.patch";
      sha256 = "11xg0clrqwvssy2r6hv4iya8g87z2v5f47fimd2b4hha6ki3g1is";
    })
    (fetchpatch {
      url = "https://src.fedoraproject.org/rpms/mutter328/raw/fff28bebda02111b4c534952465ff967ba7efced/f/0071-backends-Add-MetaInputMapper.patch";
      sha256 = "1kcp42hg8sy1q21w5586gdgmi95nf36829kkfswbah61h6bkb518";
    })
    (fetchpatch {
      url = "https://src.fedoraproject.org/rpms/mutter328/raw/fff28bebda02111b4c534952465ff967ba7efced/f/0072-backends-Delegate-on-MetaInputMapper-for-unmapped-di.patch";
      sha256 = "0zf4yxhq5s3dnzmn15mx4yb978g27ij4vmq055my9p7xgh6h9ga8";
    })
    (fetchpatch {
      url = "https://src.fedoraproject.org/rpms/mutter328/raw/fff28bebda02111b4c534952465ff967ba7efced/f/0073-backends-Add-MetaInputMapper-method-to-lookup-device.patch";
      sha256 = "0dnb2hqx5in6x9ar6wnr1hy3bg2wdcl3wbdx4jn66c7bi7s1k5zd";
    })
    (fetchpatch {
      url = "https://src.fedoraproject.org/rpms/mutter328/raw/fff28bebda02111b4c534952465ff967ba7efced/f/0074-backends-Turn-builtin-touchscreen-on-off-together-wi.patch";
      sha256 = "17fvs7j5ws4sz6fkch93gjlik0nm4z426w4n348gyw5llh0r76pg";
    })
    (fetchpatch {
      url = "https://src.fedoraproject.org/rpms/mutter328/raw/fff28bebda02111b4c534952465ff967ba7efced/f/0075-backends-Update-to-new-output-setting-for-tablets-to.patch";
      sha256 = "141p3an83s042f67fw2fqmr79i5g634ndrbpd8cs47fd4wwiwpj5";
    })
  ];

  configureFlags = [
    "--with-x"
    "--disable-static"
    "--enable-shape"
    "--enable-sm"
    "--enable-startup-notification"
    "--enable-xsync"
    "--enable-verbose-mode"
    "--with-libcanberra"
    "--with-xwayland-path=${xwayland}/bin/Xwayland"
    "--enable-compile-warnings=maximum"
  ];

  propagatedBuildInputs = [
    # required for pkgconfig to detect mutter-clutter
    libXtst
  ];

  nativeBuildInputs = [ autoreconfHook pkgconfig intltool libtool wrapGAppsHook ];

  buildInputs = [
    glib gobject-introspection gtk3 gsettings-desktop-schemas upower
    gnome-desktop cairo pango cogl clutter zenity libstartup_notification
    geocode-glib libinput libgudev libwacom
    libcanberra-gtk3 zenity xkeyboard_config libxkbfile
    libxkbcommon
  ];

  enableParallelBuilding = true;

  meta = with stdenv.lib; {
    platforms = platforms.linux;
    maintainers = gnome3.maintainers;
    license = licenses.gpl2;
  };
}
