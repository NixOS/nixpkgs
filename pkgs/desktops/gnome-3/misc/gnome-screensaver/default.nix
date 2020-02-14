{ stdenv
, fetchgit
, autoreconfHook
, dbus-glib
, glib
, gnome-common
, gnome-desktop
, gnome3
, gtk3
, pkgconfig
, intltool
, pam
, systemd
, wrapGAppsHook
}:

stdenv.mkDerivation rec {
  pname = "gnome-screensaver";
  version = "3.6.1";

  # the original package is deprecated and the Ubuntu version has a number of useful patches
  src = fetchgit {
    url = "https://git.launchpad.net/ubuntu/+source/gnome-screensaver";
    rev =  "4f7b666131dec060a5aac9117f395ac522a627b4";
    sha256 = "15xqgcpm825cy3rm8pj00qlblq66svmh06lcw8qi74a3g0xcir87";
  };

  # from debian/patches/series
  patches = map (patch: "debian/patches/${patch}") [
    "00git_logind_check.patch"
    "01_no_autostart.patch"
    "03_fix_ltsp-fading.patch"
    "05_dbus_service.patch"
    "10_legacy_scrsvr_inhibit.patch"
    "13_nvidia_gamma_fade_fallback.patch"
    "14_no_fade_on_user_switch.patch"
    "15_dont_crash_on_no_fade.patch"
    "16_dont_crash_in_kvm.patch"
    "17_remove_top_panel.patch"
    "18_unity_dialog_layout.patch"
    "24_use_user_settings.patch"
    "25_fix_lock_command.patch"
    "27_lightdm_switch_user.patch"
    "28_blocking_return.patch"
    "29_handle_expired_creds.patch"
    # these two patches are ubuntu-specific
    # "30_ubuntu-lock-on-suspend_gsetting.patch"
    # "31_lock_screen_on_suspend.patch"
    "32_input_sources_switcher.patch"
    "move-not-nuke.patch"
    "allow-replacement"
    "libsystemd.patch"
    "0001-gs-lock-plug-Disconnect-signal-handler-from-right-ob.patch"
    "33_budgie_support.patch"
  ] ++ [ ./fix-dbus-service-dir.patch ];

  nativeBuildInputs = [
    autoreconfHook
    intltool
    wrapGAppsHook
    gnome-common
    pkgconfig
  ];

  buildInputs = [
    glib
    gtk3
    gnome-desktop
    dbus-glib
    pam
    systemd
  ];

  NIX_CFLAGS_COMPILE = [ "-Wno-error=return-type" ];

  configureFlags = [ "--enable-locking" "--with-systemd=yes" ];

  enableParallelBuilding = true;

  doCheck = true;

  passthru = {
    updateScript = gnome3.updateScript {
      packageName = pname;
      attrPath = "gnome3.${pname}";
    };
  };

  meta = with stdenv.lib; {
    description = "Component of Gnome Flashback that provides screen locking";
    homepage = https://wiki.gnome.org/Projects/GnomeScreensaver;
    license = licenses.gpl2Plus;
    maintainers = gnome3.maintainers;
    platforms = platforms.linux;
  };
}
