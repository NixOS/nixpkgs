{ stdenv
, fetchFromGitHub
, pantheon
, substituteAll
, meson
, ninja
, pkgconfig
, vala
, libgee
, granite
, gtk3
, switchboard
, pciutils
, elementary-feedback
}:

stdenv.mkDerivation rec {
  pname = "switchboard-plug-about";
  version = "2.6.3";

  src = fetchFromGitHub {
    owner = "elementary";
    repo = pname;
    rev = version;
    sha256 = "sha256-wis6wNEOOjPLUCT9vRRhMxbKHR2Y2nZArKogSF/FQv8=";
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

  patches = [
    (substituteAll {
      src = ./fix-paths.patch;
      inherit pciutils;
      elementary_feedback = elementary-feedback;
    })
  ];

  meta = with stdenv.lib; {
    description = "Switchboard About Plug";
    homepage = https://github.com/elementary/switchboard-plug-about;
    license = licenses.gpl3Plus;
    platforms = platforms.linux;
    maintainers = pantheon.maintainers;
  };

}
