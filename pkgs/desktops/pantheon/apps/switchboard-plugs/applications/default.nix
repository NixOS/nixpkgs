{ stdenv
, fetchFromGitHub
, pantheon
, meson
, ninja
, pkgconfig
, vala
, libgee
, granite
, gtk3
, switchboard
}:

stdenv.mkDerivation rec {
  pname = "switchboard-plug-applications";
  version = "2.1.6";

  src = fetchFromGitHub {
    owner = "elementary";
    repo = pname;
    rev = version;
    sha256 = "19l979sdn9jzibvn98ag3ys28ka7zqlsbs0gj2gs9jcxhzngrxvg";
  };

  passthru = {
    updateScript = pantheon.updateScript {
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
    granite
    gtk3
    libgee
    switchboard
  ];

  meta = with stdenv.lib; {
    description = "Switchboard Applications Plug";
    homepage = https://github.com/elementary/switchboard-plug-applications;
    license = licenses.gpl2Plus;
    platforms = platforms.linux;
    maintainers = pantheon.maintainers;
  };
}
