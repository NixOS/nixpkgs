{ stdenv, fetchFromGitHub, pantheon, pkgconfig, meson, ninja
, vala, gtk3, libgee, polkit, gobject-introspection, wrapGAppsHook }:

stdenv.mkDerivation rec {
  pname = "pantheon-agent-polkit";
  version = "0.1.6";

  src = fetchFromGitHub {
    owner = "elementary";
    repo = pname;
    rev = version;
    sha256 = "1g9l2jzpvv0dbvxh93w98a7ijsfqv3s3382li4s256179gihhd67";
  };

  passthru = {
    updateScript = pantheon.updateScript {
      repoName = pname;
    };
  };

  nativeBuildInputs = [
    gobject-introspection
    meson
    ninja
    pkgconfig
    vala
    wrapGAppsHook
  ];

  buildInputs = [
    gtk3
    libgee
    polkit
  ];

  meta = with stdenv.lib; {
    description = "Polkit Agent for the Pantheon Desktop";
    homepage = https://github.com/elementary/pantheon-agent-polkit;
    license = licenses.lgpl21Plus;
    platforms = platforms.linux;
    maintainers = pantheon.maintainers;
  };
}
