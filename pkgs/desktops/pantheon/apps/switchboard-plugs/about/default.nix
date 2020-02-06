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
  version = "2.6.1";

  src = fetchFromGitHub {
    owner = "elementary";
    repo = pname;
    rev = version;
    sha256 = "1z58d21xrjghvjx0ng53pcxwdk2f5d00dvngcyjja0kf7sixba71";
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
