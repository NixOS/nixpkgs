{
  lib,
  stdenv,
  fetchurl,
  fetchpatch,
  autoconf-archive,
  autoreconfHook,
  pkg-config,
  glib,
  gnome,
  libxml2,
  libgdata,
  grilo,
  libzapojit,
  grilo-plugins,
  gnome-online-accounts,
  libmediaart,
  tracker,
  gfbgraph,
  librest,
  libsoup,
  json-glib,
  gmp,
  openssl,
  dleyna-server,
  wrapGAppsHook3,
}:

stdenv.mkDerivation rec {
  pname = "gnome-online-miners";
  version = "3.34.0";

  src = fetchurl {
    url = "mirror://gnome/sources/gnome-online-miners/${lib.versions.majorMinor version}/${pname}-${version}.tar.xz";
    sha256 = "1n2jz9i8a42zwxx5h8j2gdy6q1vyydh4vl00r0al7w8jzdh24p44";
  };

  patches = [
    # Fix use after free
    # https://gitlab.gnome.org/GNOME/gnome-online-miners/merge_requests/4
    (fetchpatch {
      url = "https://gitlab.gnome.org/GNOME/gnome-online-miners/commit/9eb57c6a8cd1a925c508646edae936eee0a8e46b.patch";
      sha256 = "O1GRnzs33I0mFzrNDFkTGiBKstq5krYg7fwj60367TA=";
    })

    # Port to Tracker 3
    # https://gitlab.gnome.org/GNOME/gnome-online-miners/merge_requests/3
    (fetchpatch {
      url = "https://gitlab.gnome.org/GNOME/gnome-online-miners/commit/2d3798252807cad9eb061ed2b37e35170c1a1daf.patch";
      sha256 = "hwrkxroMpTfOwJAPkYQFdDCroZ2qSsvOgDetrJDig20=";
    })
    (fetchpatch {
      url = "https://gitlab.gnome.org/GNOME/gnome-online-miners/commit/1548c0c527f0e4389047448d7d3b6cff55278c8e.patch";
      sha256 = "U9w81c9Kze7kv5KHeGqvDeSNHzSayVrUG0XYsYMa1sg=";
    })
    (fetchpatch {
      url = "https://gitlab.gnome.org/GNOME/gnome-online-miners/commit/941ebd8890c9ac4f75a1f58ccbea9731f46ad912.patch";
      sha256 = "JHtDlZ54/BlSiUA3ROHfCTtTKSin3g6JNm8NS6pYML8=";
    })
    (fetchpatch {
      url = "https://gitlab.gnome.org/GNOME/gnome-online-miners/commit/d1681a64bc3f65894af2549e3ba2bffbaf6f539a.patch";
      sha256 = "9ZEatz5I81UAnjS1qCGWYDQQOxg/qp9Tg3xG/a+3goc=";
    })
    (fetchpatch {
      url = "https://gitlab.gnome.org/GNOME/gnome-online-miners/commit/3d2af8785c84d6e50d8a8e6a2569a4b709184e94.patch";
      sha256 = "7bdUE2k6g3Z8sdGYEb6pUm1/wbKDe4BHbylXUzfuTG0=";
    })
  ];

  nativeBuildInputs = [
    # patch changes configure.ac
    autoconf-archive
    autoreconfHook

    pkg-config
    wrapGAppsHook3
  ];

  buildInputs = [
    glib
    libgdata
    libxml2
    libsoup
    gmp
    openssl
    grilo
    libzapojit
    grilo-plugins
    gnome-online-accounts
    libmediaart
    tracker
    gfbgraph
    json-glib
    librest
    dleyna-server
  ];

  env.NIX_CFLAGS_COMPILE = toString [
    "-Wno-error=format-security" # https://gitlab.gnome.org/GNOME/gnome-online-miners/merge_requests/3/diffs#note_942747
  ];

  enableParallelBuilding = true;

  passthru = {
    updateScript = gnome.updateScript {
      packageName = "gnome-online-miners";
      attrPath = "gnome.gnome-online-miners";
    };
  };

  meta = with lib; {
    homepage = "https://gitlab.gnome.org/Archive/gnome-online-miners";
    description = "A set of crawlers that go through your online content and index them locally in Tracker";
    maintainers = teams.gnome.members;
    license = licenses.gpl2Plus;
    platforms = platforms.linux;
  };
}
