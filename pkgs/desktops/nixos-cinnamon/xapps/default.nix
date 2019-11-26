{ fetchFromGitHub, glib, gobjectIntrospection, gtk3, libgnomekbd, libxklavier, meson, ninja, pkgconfig, python3, python3Packages, stdenv, vala }:

stdenv.mkDerivation rec {
  pname = "xapps";
  version = "1.4.7";

  src = fetchFromGitHub {
    owner = "linuxmint";
    repo = "xapps";
    rev = "${version}";
    sha256 = "0q0gjri9vqiz7aypnm7s48hq27s3619jmw6vxlf3rnn62viczp7q";
  };

  patches = [ ./py-override.patch ];

  buildInputs = [ glib gobjectIntrospection gtk3 libgnomekbd libxklavier pkgconfig python3Packages.pygobject3 vala ];
  nativeBuildInputs = [ meson ninja python3 ];

   mesonFlags = [
    "-Dpy-overrides-dir=${placeholder "out"}/${python3.sitePackages}/gi/overrides"
   ];

  postPatch = ''
    chmod +x schemas/meson_install_schemas.py # patchShebangs requires executable file

    patchShebangs schemas/meson_install_schemas.py

    substituteInPlace files/meson.build \
      --replace "'/'" "'$prefix/'"
  '';
}
