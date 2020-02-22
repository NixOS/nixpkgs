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
, switchboard
}:

stdenv.mkDerivation rec {
  pname = "switchboard-plug-sharing";
  version = "2.1.3";

  src = fetchFromGitHub {
    owner = "elementary";
    repo = pname;
    rev = version;
    sha256 = "1yi6aga9i18wwn22zwmfbhsk16f92fka837is5r8xghqb7a50hyh";
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
    # Fix build with latest vala
    (fetchpatch {
      url = "https://github.com/elementary/switchboard-plug-sharing/commit/22c9d52577a2e8c36c840a99009420266a39e1fe.patch";
      sha256 = "0rbf1yxhc7k44cwikd45mv2g6slzw0rkwn5s38q3yxai9jnpvqch";
    })
  ];

  PKG_CONFIG_SWITCHBOARD_2_0_PLUGSDIR = "${placeholder "out"}/lib/switchboard";

  meta = with stdenv.lib; {
    description = "Switchboard Sharing Plug";
    homepage = https://github.com/elementary/switchboard-plug-sharing;
    license = licenses.gpl2Plus;
    platforms = platforms.linux;
    maintainers = pantheon.maintainers;
  };
}
