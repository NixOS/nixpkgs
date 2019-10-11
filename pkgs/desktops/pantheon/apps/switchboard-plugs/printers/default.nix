{ stdenv
, fetchFromGitHub
, fetchpatch
, pantheon
, meson
, ninja
, pkgconfig
, vala
, libgee
, granite
, gtk3
, cups
, switchboard
}:

stdenv.mkDerivation rec {
  pname = "switchboard-plug-printers";
  version = "2.1.6";

  src = fetchFromGitHub {
    owner = "elementary";
    repo = pname;
    rev = version;
    sha256 = "05pkf3whh51gd9d0h2h4clgf7r3mvzl4ybas7834vhy19dzcbzmc";
  };

  passthru = {
    updateScript = pantheon.updateScript {
      repoName = pname;
    };
  };

  nativeBuildInputs = [
    meson
    ninja
    pkgconfig
    vala
  ];

  buildInputs = [
    cups
    granite
    gtk3
    libgee
    switchboard
  ];

  patches = [
    # Fix build with latest vala.
    (fetchpatch {
      url = "https://github.com/elementary/switchboard-plug-printers/commit/3175c2ebf106145a95355d2571e0a2aa4834e884.patch";
      sha256 = "1b2q48a1284037nz79vjcrz8g2qpsyg7s5rag6bfp03a1ijb7gw3";
    })
  ];

  PKG_CONFIG_SWITCHBOARD_2_0_PLUGSDIR = "${placeholder "out"}/lib/switchboard";

  meta = with stdenv.lib; {
    description = "Switchboard Printers Plug";
    homepage = https://github.com/elementary/switchboard-plug-printers;
    license = licenses.lgpl3Plus;
    platforms = platforms.linux;
    maintainers = pantheon.maintainers;
  };

}
