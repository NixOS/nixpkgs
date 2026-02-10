{
  lib,
  stdenv,
  fetchurl,
  pkg-config,
  intltool,
  openssl,
  curl,
  libnotify,
  libappindicator-gtk3,
  gst_all_1,
  gtk3,
  dconf,
  wrapGAppsHook3,
  aria2,
  # Boolean guards
  aria2Support ? true,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "uget";
  version = "2.2.3-1";

  src = fetchurl {
    url = "mirror://sourceforge/urlget/uget-${finalAttrs.version}.tar.gz";
    sha256 = "0jchvgkkphhwp2z7vd4axxr9ns8b6vqc22b2z8a906qm8916wd8i";
  };

  patches = [
    # Fix build with gcc15
    #   UgtkMenubar.c:188:19: error: too many arguments to function 'ugtk_setting_dialog_new'; expected 0, have 2
    #   UgtkSettingDialog.c:50:21: error: conflicting types for 'ugtk_setting_dialog_new'; have 'UgtkSettingDialog *(const gchar *, GtkWindow *)' {aka 'UgtkSettingDialog *(const char *, struct _GtkWindow *)'}
    ./fix-match-ugtk_setting_dialog_new-declaration-with-d.patch
  ];

  # Apply upstream fix for -fno-common toolchains.
  postPatch = ''
    # TODO: remove the replace once upstream fix is released:
    #   https://sourceforge.net/p/urlget/uget2/ci/14890943c52e0a5cd2a87d8a1c51cbffebee7cf9/
    substituteInPlace ui-gtk/UgtkBanner.h --replace "} banner;" "};"
  '';

  nativeBuildInputs = [
    pkg-config
    intltool
    wrapGAppsHook3
  ];

  buildInputs = [
    openssl
    curl
    libnotify
    libappindicator-gtk3
    gtk3
    (lib.getLib dconf)
  ]
  ++ (with gst_all_1; [
    gstreamer
    gst-plugins-base
    gst-plugins-good
  ])
  ++ (lib.optional aria2Support aria2);

  enableParallelBuilding = true;

  preFixup = lib.optionalString aria2Support ''gappsWrapperArgs+=(--suffix PATH : "${aria2}/bin")'';

  meta = {
    description = "Download manager using GTK and libcurl";
    longDescription = ''
      uGet is a VERY Powerful download manager application with a large
      inventory of features but is still very light-weight and low on
      resources, so don't let the impressive list of features scare you into
      thinking that it "might be too powerful" because remember power is good
      and lightweight power is uGet!
    '';
    homepage = "http://www.ugetdm.com";
    license = lib.licenses.lgpl21;
    platforms = lib.platforms.unix;
    maintainers = with lib.maintainers; [ romildo ];
    mainProgram = "uget-gtk";
  };
})
