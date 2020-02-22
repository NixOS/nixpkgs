{ stdenv
, fetchFromGitHub
, pantheon
, pkgconfig
, meson
, ninja
, vala
, gtk3
, granite
, wingpanel
, libgee
, libxml2
}:

stdenv.mkDerivation rec {
  pname = "wingpanel-indicator-nightlight";
  version = "2.0.2";

  src = fetchFromGitHub {
    owner = "elementary";
    repo = pname;
    rev = version;
    sha256 = "0kw83ws91688xg96k9034dnz15szx2kva9smh1nb7xmdbpzn3qph";
  };

  passthru = {
    updateScript = pantheon.updateScript {
      attrPath = "pantheon.${pname}";
    };
  };

  nativeBuildInputs = [
    libxml2
    meson
    ninja
    pkgconfig
    vala
  ];

  buildInputs = [
    granite
    gtk3
    libgee
    wingpanel
  ];

  PKG_CONFIG_WINGPANEL_2_0_INDICATORSDIR = "${placeholder "out"}/lib/wingpanel";

  meta = with stdenv.lib; {
    description = "Night Light Indicator for Wingpanel";
    homepage = https://github.com/elementary/wingpanel-indicator-nightlight;
    license = licenses.gpl2Plus;
    platforms = platforms.linux;
    maintainers = pantheon.maintainers;
  };
}
