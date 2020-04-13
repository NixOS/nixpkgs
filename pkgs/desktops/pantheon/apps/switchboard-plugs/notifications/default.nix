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
, elementary-notifications
}:

stdenv.mkDerivation rec {
  pname = "switchboard-plug-notifications";
  version = "2.1.6";

  src = fetchFromGitHub {
    owner = "elementary";
    repo = pname;
    rev = version;
    sha256 = "1ikq058svdan0whg4ks35m50apvbmzcz7h2wznxdbsimczzvj5sz";
  };

  patches = [
    # Fix do not disturb on NixOS
    # https://github.com/elementary/switchboard-plug-notifications/pull/66
    (fetchpatch {
      url = "https://github.com/elementary/switchboard-plug-notifications/commit/c306366b39c3199f0b64eda73419005fcb5e29b8.patch";
      sha256 = "0m018rfw5iv582sw6qgwc8lzn0j32ix1w47fvlfmx0kw04irl2x3";
    })
  ];

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
