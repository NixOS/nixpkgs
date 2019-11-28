{ fetchFromGitHub, glib, gobjectIntrospection, gtk3, libgnomekbd, libxklavier, meson, ninja, pkgconfig, python3, python3Packages, stdenv, vala, wrapGAppsHook }:

stdenv.mkDerivation rec {
  pname = "xapps";
  version = "1.6.4";

  src = fetchFromGitHub {
    owner = "linuxmint";
    repo = pname;
    rev = version;
    sha256 = "08c8j7wv56zf8mfgjfhd0wc1bbrw0dj1lmlawvsxwfajnnyjsm0d";
  };

  NIX_CFLAGS_COMPILE = [ "-I${glib.dev}/include/gio-unix-2.0" ];

  patches = [
    ./py-override.patch
  ];

  buildInputs = [ glib gobjectIntrospection gtk3 libgnomekbd libxklavier pkgconfig python3Packages.pygobject3 vala ];
  nativeBuildInputs = [ meson ninja python3 wrapGAppsHook ];

  mesonFlags = [
    "-Dpy-overrides-dir=${placeholder "out"}/${python3.sitePackages}/gi/overrides"
  ];

  preBuild = ''
    chmod +x /build/source/libxapp/g-codegen.py
    patchShebangs /build/source/libxapp/g-codegen.py
    pwd
    '';

  postPatch = ''
    chmod +x schemas/meson_install_schemas.py # patchShebangs requires executable file

    patchShebangs schemas/meson_install_schemas.py

    substituteInPlace files/meson.build \
      --replace "'/'" "'$prefix/'"
  '';

  meta = with stdenv.lib; {
    homepage = "https://github.com/linuxmint/xapps";
    description = "Cross-desktop libraries and common resources";

    platforms = platforms.linux;
    maintainers = [ maintainers.mkg20001 ];
  };
}
