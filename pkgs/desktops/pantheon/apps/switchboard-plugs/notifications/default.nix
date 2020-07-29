{ stdenv
, fetchFromGitHub
, nix-update-script
, fetchpatch
, pantheon
, meson
, ninja
, pkgconfig
, vala
, libgee
, granite
, gtk3
, switchboard
, elementary-notifications
}:

stdenv.mkDerivation rec {
  pname = "switchboard-plug-notifications";
  version = "2.1.7";

  src = fetchFromGitHub {
    owner = "elementary";
    repo = pname;
    rev = version;
    sha256 = "02amm2j6blpfc16p5rm64p8shnppzsg49hz4v196mli5xr1r441h";
  };

  passthru = {
    updateScript = nix-update-script {
      attrPath = "pantheon.${pname}";
    };
  };

  nativeBuildInputs = [
    meson
    ninja
    pkgconfig
    vala
  ];

  buildInputs = [
    elementary-notifications
    granite
    gtk3
    libgee
    switchboard
  ];

  meta = with stdenv.lib; {
    description = "Switchboard Notifications Plug";
    homepage = "https://github.com/elementary/switchboard-plug-notifications";
    license = licenses.gpl2Plus;
    platforms = platforms.linux;
    maintainers = pantheon.maintainers;
  };
}
