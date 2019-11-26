{ fetchFromGitHub, glib, gobjectIntrospection, gtk3, libgnomekbd, libxklavier, meson, ninja, pkgconfig, python3, python3Packages, stdenv, vala, wrapGAppsHook }:

stdenv.mkDerivation rec {
  pname = "xapps";
  version = "1.6.2";

  src = fetchFromGitHub {
    owner = "linuxmint";
    repo = "xapps";
    rev = "${version}";
    sha256 = "08fkypbx1j1kp3hp0y88idbj0la17hjwmw2w6f6jijwdipgwax7b";
  };

  patches = [
    ./py-override.patch
  ];

  buildInputs = [ glib gobjectIntrospection gtk3 libgnomekbd libxklavier pkgconfig python3Packages.pygobject3 vala wayland ];
  nativeBuildInputs = [ meson ninja python3 wrapGAppsHook ];

   mesonFlags = [
    "-Dpy-overrides-dir=${placeholder "out"}/${python3.sitePackages}/gi/overrides"
   ];

  postPatch = ''
    chmod +x schemas/meson_install_schemas.py # patchShebangs requires executable file

    patchShebangs schemas/meson_install_schemas.py

    substituteInPlace files/meson.build \
      --replace "'/'" "'$prefix/'"
  '';

  meta = {
    homepage = "http://cinnamon.linuxmint.com";
    # description = "The cinnamon session files" ;

    platforms = stdenv.lib.platforms.linux;
    maintainers = [ stdenv.lib.maintainers.mkg20001 ];
  };
}
