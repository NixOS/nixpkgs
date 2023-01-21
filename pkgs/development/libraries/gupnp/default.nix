{ stdenv
, lib
, fetchurl
, meson
, ninja
, pkg-config
, gobject-introspection
, vala
, libxslt
, gi-docgen
, glib
, gssdp
, libsoup_3
, libxml2
, libuuid
, gnome
, python3
}:

stdenv.mkDerivation rec {
  pname = "gupnp";
  version = "1.6.1";

  outputs = [ "out" "dev" ];

  src = fetchurl {
    url = "mirror://gnome/sources/gupnp/${lib.versions.majorMinor version}/${pname}-${version}.tar.xz";
    sha256 = "sha256-hTgUUtKvlbjhSyTUqYljPQ2DzYjRJy8nzLJBbMyDbUc=";
  };

  postPatch = ''
    patchShebangs subprojects/gi-docgen/gi-docgen.py
  '';

  depsBuildBuild = [
    pkg-config
  ];

  nativeBuildInputs = [
    meson
    ninja
    pkg-config
    gobject-introspection
    vala
    libxslt
    gi-docgen
    (python3.withPackages (p: with p; [ jinja2 markdown markupsafe pygments toml typogrify ]))
  ];

  buildInputs = [
    libuuid
  ];

  propagatedBuildInputs = [
    glib
    gssdp
    libsoup_3
    libxml2
  ];

  mesonFlags = [
    "-Dgtk_doc=${lib.boolToString (stdenv.buildPlatform == stdenv.hostPlatform)}"
    "-Dintrospection=${lib.boolToString (stdenv.buildPlatform == stdenv.hostPlatform)}"
  ];

  # Bail out! ERROR:../tests/test-bugs.c:168:test_on_timeout: code should not be reached
  doCheck = !stdenv.isDarwin;

  passthru = {
    updateScript = gnome.updateScript {
      packageName = pname;
      freeze = true;
    };
  };

  meta = with lib; {
    homepage = "http://www.gupnp.org/";
    description = "An implementation of the UPnP specification";
    license = licenses.lgpl2Plus;
    platforms = platforms.unix;
  };
}
